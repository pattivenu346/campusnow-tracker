# Campus Workboard

A responsive, local-first team workflow board built with React, TypeScript, and Vite. It provides an administrator view, member-restricted task workflow, automatic overdue backlog movement, filtering, import/export, and persistent browser storage.

## Run locally

```bash
npm install
npm run dev
```

For a deployment build:

```bash
npm run build
npm run preview
```

Vercel can deploy this repository using its normal Vite detection and build command (`npm run build`). No environment variables, backend, or database are required.

## Default accounts

- Administrator and team credentials are stored only in `src/data.ts`. They are intentionally not displayed by the application UI.

Accounts and display names are configured in `src/data.ts`. The workspace deliberately starts empty; every displayed task is a persisted record created by an administrator.

## Storage and security

All state is saved to this browser’s `localStorage` under `teamTaskTrackerData`; the session is stored under `taskTrackerSession`. This means data is **not shared across browsers or devices**, and authentication is suitable only for a local demo/internal workflow—not real security.

Administrators can use **Data** to export the workspace to `team-task-tracker-backup.json` and import it in another browser. Import replaces the current local workspace after confirmation.

## Workflow

Tasks start in TODO. Members may move their own work through TODO → IN PROGRESS → REVIEW → DONE (or return review work to progress). Admins can create, edit, delete, reassign, and move any task. When the app loads or regains focus, non-completed tasks past their local-date deadline automatically move to BACKLOG while preserving their previous status.
