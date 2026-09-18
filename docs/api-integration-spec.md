# DSH HarmonyOS Client — DSH API 集成规格

> 本文档定义 HarmonyOS 客户端与 DSH Server 的通信协议、数据模型和集成点。

---

## 1. 通信协议

### 1.1 传输层

- **协议**：HTTP/HTTPS
- **端点**：`http://{server}:{port}/api`
- **格式**：JSON-RPC 2.0
- **编码**：UTF-8

### 1.2 请求格式

```typescript
interface ClientRequest {
  type: 'request';
  rpcId: string;        // 唯一请求 ID
  method: string;       // API 方法名
  payload: object;      // 方法参数
}
```

### 1.3 响应格式

```typescript
interface ServerResponse {
  type: 'response';
  rpcId: string;        // 对应请求的 ID
  result: object;       // 方法返回值
  error?: object;       // 错误信息（可选）
}
```

---

## 2. API 方法清单

### 2.1 会话管理

| 方法 | 说明 | 参数 | 返回值 |
|------|------|------|--------|
| `session/list` | 获取会话列表 | `{ workspace?: string }` | `Session[]` |
| `session/create` | 创建新会话 | `{ workspace?: string, title?: string, model?: string }` | `Session` |
| `session/prompt` | 发送消息 | `{ sessionId: string, content: string }` | `Message` |
| `session/follow` | 跟进对话 | `{ sessionId: string, content: string }` | `Message` |
| `session/control` | 控制会话 | `{ sessionId: string, action: string }` | `void` |
| `session/cancel` | 取消会话 | `{ sessionId: string }` | `void` |
| `session/search` | 搜索会话 | `{ query: string, workspace?: string }` | `SearchResult[]` |

### 2.2 模型管理

| 方法 | 说明 | 参数 | 返回值 |
|------|------|------|--------|
| `session/selectModel` | 切换模型 | `{ sessionId: string, model: string }` | `void` |

### 2.3 工具调用审批

| 方法 | 说明 | 参数 | 返回值 |
|------|------|------|--------|
| `session/approve` | 批准工具调用 | `{ sessionId: string, toolCallId: string }` | `void` |
| `session/reject` | 拒绝工具调用 | `{ sessionId: string, toolCallId: string }` | `void` |

---

## 3. 数据模型

### 3.1 Session

```typescript
interface Session {
  id: string;              // 会话唯一 ID
  title: string;           // 会话标题
  workspace: string;       // 所属工作区
  model: string;           // 当前模型
  createdAt: string;       // 创建时间 (ISO 8601)
  updatedAt: string;       // 最后更新时间
  messageCount: number;    // 消息数量
  status: 'active' | 'idle' | 'error';  // 会话状态
  agent?: {                // Agent 信息（运行中时存在）
    status: 'running' | 'waiting_approval';
    currentTool?: string;  // 当前执行的工具
    toolCallId?: string;   // 等待审批的工具调用 ID
  };
}
```

### 3.2 Message

```typescript
interface Message {
  id: string;              // 消息唯一 ID
  sessionId: string;       // 所属会话 ID
  role: 'user' | 'assistant' | 'system';  // 消息角色
  content: string;         // 文本内容
  toolCalls?: ToolCall[];  // 工具调用（assistant 消息）
  timestamp: string;       // 发送时间
}
```

### 3.3 ToolCall

```typescript
interface ToolCall {
  id: string;              // 工具调用 ID
  type: string;            // 工具类型 (read_file, write_file, bash, search)
  name: string;            // 工具名称
  parameters: object;      // 工具参数
  status: 'pending' | 'running' | 'completed' | 'failed' | 'approval_required';
  result?: string;         // 执行结果
  error?: string;          // 错误信息
  duration?: number;       // 执行时长 (ms)
}
```

### 3.4 SearchResult

```typescript
interface SearchResult {
  sessionId: string;       // 会话 ID
  title: string;           // 会话标题
  workspace: string;       // 所属工作区
  snippet: string;         // 匹配内容摘要
  score: number;           // 匹配度 (0-1)
}
```

---

## 4. 集成点映射

### 4.1 UI 组件 → API 调用

| UI 操作 | API 调用 | 说明 |
|---------|---------|------|
| App 启动 | `session/list` | 加载会话列表 |
| 搜索框输入 | `session/search` | 实时搜索会话 |
| 点击 FAB (+) | `session/create` | 创建新会话 |
| 点击会话项 | — | 进入聊天页面（加载历史消息） |
| 输入框发送 | `session/prompt` | 发送用户消息 |
| 点击允许 | `session/approve` | 批准工具调用 |
| 点击拒绝 | `session/reject` | 拒绝工具调用 |
| ⋯ 菜单切换模型 | `session/selectModel` | 切换会话模型 |
| ⋯ 菜单收藏 | — | 本地操作（Preferences） |
| ⋯ 菜单重命名 | `session/rename` | 修改会话标题 |
| ⋯ 菜单导出 | — | 本地导出 JSON |
| ⋯ 菜单分叉 | `session/fork` | 创建会话分支 |

### 4.2 实时更新

DSH Server 支持 SSE (Server-Sent Events) 或 WebSocket 推送：

- **消息流**：assistant 消息逐 token 推送
- **工具调用状态**：工具执行开始/完成/失败
- **Agent 状态**：running → waiting_approval → running → idle

---

## 5. 错误处理

### 5.1 连接错误

| 错误码 | 说明 | 处理 |
|--------|------|------|
| `ECONNREFUSED` | 服务器不可达 | 显示连接失败页面，提供重试按钮 |
| `ETIMEDOUT` | 连接超时 | 显示超时提示，自动重试 3 次 |
| `ENOTFOUND` | DNS 解析失败 | 提示检查服务器地址 |

### 5.2 API 错误

| 错误码 | 说明 | 处理 |
|--------|------|------|
| 401 | 未授权 | 跳转认证页面 |
| 403 | 禁止访问 | 提示权限不足 |
| 404 | 资源不存在 | 提示会话/服务器不存在 |
| 500 | 服务器错误 | 显示错误提示，建议重试 |

### 5.3 超时处理

| 操作 | 超时时间 | 处理 |
|------|---------|------|
| 连接 | 10s | 显示连接失败 |
| API 请求 | 30s | 显示请求超时 |
| 工具执行 | 120s | 显示执行超时，可取消 |

---

## 6. 本地存储

### 6.1 收藏数据

使用 HarmonyOS Preferences 存储：

```typescript
interface FavoriteRecord {
  sessionId: string;
  serverName: string;
  title: string;
  favoritedAt: string;  // ISO 8601
}
```

### 6.2 应用设置

```typescript
interface AppSettings {
  language: string;      // 默认 'zh-CN'
  theme: 'dark' | 'light';  // 默认 'dark'
  fontSize: 'small' | 'medium' | 'large';  // 默认 'medium'
}
```

### 6.3 服务器配置

```typescript
interface ServerConfig {
  name: string;          // 服务器名称
  url: string;           // 服务器地址
  token?: string;        // 认证 Token（可选）
  workspace?: string;    // 默认工作区
  connectedAt: string;   // 连接时间
}
```
