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

## Vercel deployment

This project is configured for Vercel in `vercel.json`. No environment variables, backend, or database are required.

1. Push this folder to a GitHub, GitLab, or Bitbucket repository.
2. In Vercel, choose **Add New → Project** and import the repository.
3. Vercel detects the Vite setup. Keep the build command as `npm run build` and output directory as `dist`.
4. Click **Deploy**.

The site is fully static, so it can also be deployed by connecting a Vercel project to the repository through the normal Git deployment flow. `npm ci` is safe to use because `package-lock.json` is committed.

## Default accounts

- Administrator and team credentials are stored only in `src/data.ts`. They are intentionally not displayed by the application UI.

Accounts and display names are configured in `src/data.ts`. The workspace deliberately starts empty; every displayed task is a persisted record created by an administrator.

## Storage and security

## Shared Supabase workspace

To enable shared tasks across team devices, run `supabase/schema.sql` in the Supabase SQL Editor, then add `VITE_SUPABASE_URL` and `VITE_SUPABASE_ANON_KEY` to Vercel. See `.env.example` for the required names. The app falls back to local browser storage until both values are configured.

All state is saved to this browser’s `localStorage` under `teamTaskTrackerData`; the session is stored under `taskTrackerSession`. This means data is **not shared across browsers or devices**, and authentication is suitable only for a local demo/internal workflow—not real security.

Administrators can use **Data** to export the workspace to `team-task-tracker-backup.json` and import it in another browser. Import replaces the current local workspace after confirmation.

## Workflow

Tasks start in TODO. Members may move their own work through TODO → IN PROGRESS → REVIEW → DONE (or return review work to progress). Admins can create, edit, delete, reassign, and move any task. When the app loads or regains focus, non-completed tasks past their local-date deadline automatically move to BACKLOG while preserving their previous status.
