// DataModel.ets
// DSH HarmonyOS Client - 数据模型定义
// 参考文档: docs/api-integration-spec.md

// ===== 会话模型 =====
export interface Session {
  id: string;              // 会话唯一 ID
  title: string;           // 会话标题
  workspace: string;       // 所属工作区
  model: string;           // 当前模型
  createdAt: string;       // 创建时间 (ISO 8601)
  updatedAt: string;       // 最后更新时间
  messageCount: number;    // 消息数量
  status: 'active' | 'idle' | 'error';  // 会话状态
  isFavorite: boolean;     // 是否收藏
}

// ===== 工作区模型 =====
export interface Workspace {
  name: string;            // 工作区名称
  icon: string;            // 图标 emoji
  gradientStart: string;   // 渐变起始色
  gradientEnd: string;     // 渐变结束色
  sessions: Session[];     // 会话列表
}

// ===== 消息模型 =====
export interface Message {
  id: string;              // 消息唯一 ID
  sessionId: string;       // 所属会话 ID
  role: 'user' | 'assistant' | 'system';  // 消息角色
  content: string;         // 文本内容
  toolCalls?: ToolCall[];  // 工具调用
  timestamp: string;       // 发送时间
}

// ===== 工具调用模型 =====
export interface ToolCall {
  id: string;              // 工具调用 ID
  type: 'read_file' | 'write_file' | 'bash' | 'search';  // 工具类型
  name: string;            // 工具名称
  filePath?: string;       // 文件路径
  content?: string;        // 代码内容
  status: 'pending' | 'running' | 'completed' | 'failed' | 'approval_required';
  result?: string;         // 执行结果
  duration?: number;       // 执行时长 (ms)
}

// ===== 服务器配置模型 =====
export interface ServerConfig {
  name: string;            // 服务器名称
  url: string;             // 服务器地址
  token?: string;          // 认证 Token
  workspace?: string;      // 默认工作区
  connected: boolean;      // 连接状态
}

// ===== 收藏记录模型 =====
export interface FavoriteRecord {
  sessionId: string;       // 会话 ID
  serverName: string;      // 服务器名称
  title: string;           // 会话标题
  model: string;           // 使用的模型
  turnCount: number;       // 对话轮数
  favoritedAt: string;     // 收藏时间
}

// ===== 应用设置模型 =====
export interface AppSettings {
  language: string;        // 语言
  theme: 'dark' | 'light'; // 主题
  fontSize: 'small' | 'medium' | 'large';  // 字体大小
}

// ===== 模型信息 =====
export interface ModelInfo {
  id: string;              // 模型 ID
  name: string;            // 模型名称
  description: string;     // 模型描述
  contextWindow: string;   // 上下文窗口
  isRecommended: boolean;  // 是否推荐
}

// ===== 权限预设 =====
export type PermissionPreset = 'readonly' | 'workspace' | 'full';

export interface PermissionPresetInfo {
  id: PermissionPreset;
  name: string;
  icon: string;
  description: string;
  bgColor: string;
}

// ===== Mock 数据 =====

// 服务器配置
export const mockServer: ServerConfig = {
  name: 'dsh-server',
  url: 'http://192.168.1.100:30080',
  workspace: 'dsh-harmonyos',
  connected: true
};

// 可用模型列表
export const mockModels: ModelInfo[] = [
  {
    id: 'mimo-v2.5',
    name: 'mimo-v2.5',
    description: '推荐 · 128K context',
    contextWindow: '128K tokens',
    isRecommended: true
  },
  {
    id: 'deepseek-chat',
    name: 'deepseek-chat',
    description: '通用 · 64K context',
    contextWindow: '64K tokens',
    isRecommended: false
  },
  {
    id: 'deepseek-coder',
    name: 'deepseek-coder',
    description: '代码 · 64K context',
    contextWindow: '64K tokens',
    isRecommended: false
  },
  {
    id: 'deepseek-reasoner',
    name: 'deepseek-reasoner',
    description: '推理 · 32K context',
    contextWindow: '32K tokens',
    isRecommended: false
  }
];

// 权限预设列表
export const mockPermissionPresets: PermissionPresetInfo[] = [
  {
    id: 'readonly',
    name: '仅可查看',
    icon: '👁',
    description: '只读，不可修改文件',
    bgColor: 'rgba(255,255,255,0.06)'
  },
  {
    id: 'workspace',
    name: '工作区内修改',
    icon: '✏️',
    description: '仅修改工作区内文件（默认）',
    bgColor: 'rgba(74,158,255,0.12)'
  },
  {
    id: 'full',
    name: '完全权限',
    icon: '🔓',
    description: '可执行任意操作',
    bgColor: 'rgba(239,68,68,0.12)'
  }
];

// 工作区列表
export const mockWorkspaces: Workspace[] = [
  {
    name: 'dsh-harmonyos',
    icon: '📁',
    gradientStart: '#4a9eff',
    gradientEnd: '#7c5cfc',
    sessions: [
      {
        id: 's1',
        title: 'HarmonyOS NEXT 开发',
        workspace: 'dsh-harmonyos',
        model: 'mimo-v2.5',
        createdAt: '2026-09-17T10:00:00Z',
        updatedAt: '2026-09-17T14:29:00Z',
        messageCount: 32,
        status: 'active',
        isFavorite: true
      },
      {
        id: 's2',
        title: 'ArkUI 组件封装',
        workspace: 'dsh-harmonyos',
        model: 'deepseek-chat',
        createdAt: '2026-09-17T08:00:00Z',
        updatedAt: '2026-09-17T12:00:00Z',
        messageCount: 12,
        status: 'idle',
        isFavorite: false
      },
      {
        id: 's3',
        title: '沉浸光感材质适配',
        workspace: 'dsh-harmonyos',
        model: 'mimo-v2.5',
        createdAt: '2026-09-16T10:00:00Z',
        updatedAt: '2026-09-16T18:00:00Z',
        messageCount: 28,
        status: 'idle',
        isFavorite: true
      },
      {
        id: 's4',
        title: 'DSH API 对接',
        workspace: 'dsh-harmonyos',
        model: 'deepseek-coder',
        createdAt: '2026-09-15T10:00:00Z',
        updatedAt: '2026-09-15T16:00:00Z',
        messageCount: 45,
        status: 'idle',
        isFavorite: false
      }
    ]
  },
  {
    name: 'dsh-docs',
    icon: '📄',
    gradientStart: '#34d399',
    gradientEnd: '#059669',
    sessions: [
      {
        id: 's5',
        title: 'API 文档生成',
        workspace: 'dsh-docs',
        model: 'mimo-v2.5',
        createdAt: '2026-09-14T10:00:00Z',
        updatedAt: '2026-09-14T16:00:00Z',
        messageCount: 8,
        status: 'idle',
        isFavorite: false
      },
      {
        id: 's6',
        title: 'README 重写',
        workspace: 'dsh-docs',
        model: 'deepseek-chat',
        createdAt: '2026-09-12T10:00:00Z',
        updatedAt: '2026-09-12T14:00:00Z',
        messageCount: 3,
        status: 'idle',
        isFavorite: false
      }
    ]
  }
];

// 收藏列表
export const mockFavorites: FavoriteRecord[] = [
  {
    sessionId: 's1',
    serverName: 'dsh-harmonyos',
    title: 'HarmonyOS NEXT 开发',
    model: 'mimo-v2.5',
    turnCount: 32,
    favoritedAt: '2026-09-17T14:00:00Z'
  },
  {
    sessionId: 's3',
    serverName: 'dsh-harmonyos',
    title: '沉浸光感材质适配',
    model: 'mimo-v2.5',
    turnCount: 28,
    favoritedAt: '2026-09-16T18:00:00Z'
  }
];

// Mock 聊天消息
export const mockMessages: Message[] = [
  {
    id: 'm1',
    sessionId: 's1',
    role: 'user',
    content: '帮我分析一下 ArkUI 的声明式 UI 语法和 React 的 JSX 有什么异同？',
    timestamp: '2026-09-17T14:00:00Z'
  },
  {
    id: 'm2',
    sessionId: 's1',
    role: 'assistant',
    content: '好的，我来对比一下 **ArkUI（ArkTS）** 和 **React（JSX）** 的声明式 UI 语法。',
    toolCalls: [
      {
        id: 'tc1',
        type: 'read_file',
        name: 'read_file',
        filePath: 'entry/src/main/ets/pages/Index.ets',
        status: 'completed',
        duration: 300
      }
    ],
    timestamp: '2026-09-17T14:00:30Z'
  },
  {
    id: 'm3',
    sessionId: 's1',
    role: 'user',
    content: '能帮我创建一个自定义组件吗？',
    timestamp: '2026-09-17T14:01:00Z'
  },
  {
    id: 'm4',
    sessionId: 's1',
    role: 'assistant',
    content: '当然可以，我来创建一个倒计时组件：',
    toolCalls: [
      {
        id: 'tc2',
        type: 'write_file',
        name: 'write_file',
        filePath: 'components/CountdownTimer.ets',
        content: `@Component\nexport struct CountdownTimer {\n  @Prop targetSeconds: number = 60\n  @State remaining: number = 0\n  @State isRunning: boolean = false\n\n  aboutToAppear() {\n    this.remaining = this.targetSeconds\n  }\n}`,
        status: 'completed',
        duration: 800
      }
    ],
    timestamp: '2026-09-17T14:01:30Z'
  }
];
