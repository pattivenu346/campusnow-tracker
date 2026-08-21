export type Status = 'BACKLOG' | 'TODO' | 'IN PROGRESS' | 'REVIEW' | 'DONE';
export type Priority = 'LOW' | 'MEDIUM' | 'HIGH' | 'URGENT';
export type Role = 'admin' | 'member';
export interface User { id: string; username: string; password: string; role: Role; name: string }
export interface Task { id: string; title: string; description: string; assignedTo: string; deadline: string; createdAt: string; updatedAt: string; status: Status; priority: Priority; notes: string; completedAt: string | null; previousStatus: Status | null; movedToBacklogAt: string | null; submittedForReviewAt: string | null }
export interface Store { users: User[]; tasks: Task[]; settings: { seeded: boolean } }
