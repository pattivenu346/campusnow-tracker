import { DEFAULT_USERS } from './data';
import type { Store, Task, User } from './types';
const KEY = 'teamTaskTrackerData'; const SESSION = 'taskTrackerSession';
export function getStore(): Store { try { const raw = localStorage.getItem(KEY); if (raw) { const stored = JSON.parse(raw) as Store; const legacy = stored.users.some(u => u.username === 'admin') || stored.tasks.some(t => t.id.startsWith('sample-')); if (!legacy) return stored; const migrated = { users: DEFAULT_USERS, tasks: [], settings: { seeded: true } }; saveStore(migrated); return migrated; } const v = { users: DEFAULT_USERS, tasks: [], settings: { seeded: true } }; saveStore(v); return v; } catch { return { users: DEFAULT_USERS, tasks: [], settings: { seeded: true } }; } }
export function saveStore(data: Store) { localStorage.setItem(KEY, JSON.stringify(data)); }
export const getSession = () => { try { return JSON.parse(localStorage.getItem(SESSION) || 'null') as string | null; } catch { return null; } };
export const saveSession = (id: string) => localStorage.setItem(SESSION, JSON.stringify(id));
export const clearSession = () => localStorage.removeItem(SESSION);
export function normaliseDeadlines(tasks: Task[]) { const today = new Date(); today.setHours(0,0,0,0); let changed = false; const result = tasks.map(t => { const deadline = new Date(`${t.deadline}T00:00:00`); if (t.status !== 'DONE' && t.status !== 'BACKLOG' && deadline < today) { changed = true; return { ...t, previousStatus: t.status, status: 'BACKLOG' as const, movedToBacklogAt: new Date().toISOString() }; } return t; }); return { result, changed }; }
export const getTasksByStatus = (tasks: Task[], status: Task['status']) => tasks.filter(t => t.status === status);
export const getTasksByMember = (tasks: Task[], userId: string) => tasks.filter(t => t.assignedTo === userId);
export const getOverdueTasks = (tasks: Task[]) => tasks.filter(t => t.status !== 'DONE' && new Date(`${t.deadline}T00:00:00`) < new Date(new Date().setHours(0,0,0,0)));
export const createTask = (tasks: Task[], task: Task) => [...tasks, task];
export const updateTask = (tasks: Task[], task: Task) => tasks.map(t => t.id === task.id ? { ...task, updatedAt: new Date().toISOString() } : t);
export const deleteTask = (tasks: Task[], id: string) => tasks.filter(t => t.id !== id);
export function validateImport(value: unknown): value is Store { const x = value as Store; return !!x && Array.isArray(x.users) && Array.isArray(x.tasks) && !!x.settings; }
export function downloadData(store: Store) { const a = document.createElement('a'); a.href = URL.createObjectURL(new Blob([JSON.stringify(store, null, 2)], { type: 'application/json' })); a.download = 'team-task-tracker-backup.json'; a.click(); URL.revokeObjectURL(a.href); }
export const getUser = (users: User[], id: string) => users.find(u => u.id === id);
