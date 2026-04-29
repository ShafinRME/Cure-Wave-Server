# 🏥 Cure Wave — Server Side

> **"Your health, our priority — anytime, anywhere."**

This is the backend REST API for **Cure Wave** — a full-stack medical care platform. It handles authentication, role-based access control, doctor & patient management, appointment scheduling, Stripe payment processing, AI-powered doctor suggestions, prescription management, and real-time dashboard analytics.

🌐 **Live API:** [https://sh-care-server-test.onrender.com](https://sh-care-server-test.onrender.com)  
🔗 **Frontend Repo:** [https://github.com/ShafinRME/Cure-Wave-Frontend](https://github.com/ShafinRME/Cure-Wave-Frontend)  
⚙️ **Backend Repo:** [https://github.com/ShafinRME/Cure-Wave-Server](https://github.com/ShafinRME/Cure-Wave-Server)

---

## 🚀 Features

- JWT-based authentication with access & refresh token rotation
- Role-based access control (Patient / Doctor / Admin / Super Admin)
- Admin-controlled doctor onboarding with mandatory first-login password change enforcement
- AI-powered doctor suggestion via OpenAI integration with dedicated rate limiting
- Full doctor, patient, admin, and specialty CRUD with Cloudinary image uploads
- Appointment booking system with pay-now and pay-later options
- Automatic appointment expiry via **node-cron** (30-minute payment window)
- Stripe webhook-based payment processing
- Doctor schedule and slot management system
- Doctor profile ownership verification on update
- Prescription management with follow-up date tracking
- Patient review system scoped to completed appointments
- Role-specific dashboard analytics and metadata
- API rate limiting per route group (auth, payment, AI, general)
- Secure environment variable management with dotenv

---

## 🧰 Tech Stack

### Backend

| Technology | Link |
|---|---|
| Node.js | [nodejs.org](https://nodejs.org) |
| Express.js v5 | [expressjs.com](https://expressjs.com) |
| TypeScript | [typescriptlang.org](https://typescriptlang.org) |
| Zod | [zod.dev](https://zod.dev) |
| date-fns | [date-fns.org](https://date-fns.org) |

### Database & ORM

| Technology | Link |
|---|---|
| PostgreSQL (Neon) | [neon.tech](https://neon.tech) |
| Prisma ORM v7 | [prisma.io](https://prisma.io) |
| @prisma/adapter-pg | [prisma.io/docs](https://www.prisma.io/docs) |

### Others

| Technology | Link |
|---|---|
| Stripe API | [stripe.com](https://stripe.com) |
| OpenAI API | [platform.openai.com](https://platform.openai.com) |
| Cloudinary | [cloudinary.com](https://cloudinary.com) |
| Nodemailer | [nodemailer.com](https://nodemailer.com) |
| bcryptjs | [npmjs.com/package/bcryptjs](https://npmjs.com/package/bcryptjs) |
| node-cron | [npmjs.com/package/node-cron](https://npmjs.com/package/node-cron) |
| Multer | [npmjs.com/package/multer](https://npmjs.com/package/multer) |
| express-rate-limit | [npmjs.com/package/express-rate-limit](https://npmjs.com/package/express-rate-limit) |
| Render | [render.com](https://render.com) |

---

## 📡 API Endpoints

> **Base URL:** `https://sh-care-server-test.onrender.com/api/v1`  
> **Rate Limiting:** Applied globally via `apiLimiter`. Auth routes use `authLimiter`. Payment routes use `paymentLimiter`. AI routes use `aiLimiter`.

---

### Auth — `/api/v1/auth`

| Method | Endpoint | Access | Description |
|---|---|---|---|
| POST | `/login` | Public | Login with email & password (rate limited) |
| POST | `/refresh-token` | Public | Obtain a new access token via refresh token |
| POST | `/change-password` | All Roles | Change current user's password |
| POST | `/forgot-password` | Public | Send password reset link via email (rate limited) |
| POST | `/reset-password` | Public / Auth | Reset password via email link or first-login flow via `flexAuth` |
| GET | `/me` | All Roles | Get currently authenticated user info |

---

### Users — `/api/v1/user`

| Method | Endpoint | Access | Description |
|---|---|---|---|
| GET | `/` | Super Admin, Admin | Get all users |
| GET | `/me` | All Roles | Get current user's profile |
| POST | `/create-admin` | Super Admin, Admin | Create a new admin account with image upload |
| POST | `/create-doctor` | Super Admin, Admin | Create a new doctor account with image upload |
| POST | `/create-patient` | Public | Register a new patient account with image upload |
| PATCH | `/:id/status` | Super Admin, Admin | Update a user's account status |
| PATCH | `/update-my-profile` | All Roles | Update current user's profile with optional image |

---

### Admins — `/api/v1/admin`

| Method | Endpoint | Access | Description |
|---|---|---|---|
| GET | `/` | Super Admin, Admin | Get all admins |
| GET | `/:id` | Super Admin, Admin | Get a single admin by ID |
| PATCH | `/:id` | Super Admin, Admin | Update admin data |
| DELETE | `/:id` | Super Admin, Admin | Permanently delete an admin |
| DELETE | `/soft/:id` | Super Admin, Admin | Soft delete an admin |

---

### Doctors — `/api/v1/doctor`

| Method | Endpoint | Access | Description |
|---|---|---|---|
| POST | `/suggestion` | Public | Get AI-powered doctor suggestions via OpenAI (rate limited via `aiLimiter`) |
| GET | `/` | Public | Get all doctors with filtering |
| GET | `/:id` | Public | Get a single doctor by ID |
| PATCH | `/:id` | Super Admin, Admin, Doctor | Update doctor profile — Doctor role enforces ownership verification in controller |
| DELETE | `/:id` | Super Admin, Admin | Permanently delete a doctor |
| DELETE | `/soft/:id` | Super Admin, Admin | Soft delete a doctor |

---

### Patients — `/api/v1/patient`

| Method | Endpoint | Access | Description |
|---|---|---|---|
| GET | `/` | Super Admin, Admin | Get all patients |
| GET | `/:id` | Super Admin, Admin, Patient | Get a single patient by ID — Patient role restricted to own record |
| PATCH | `/:id` | Super Admin, Admin, Patient | Update patient data — Patient role restricted to own record |
| DELETE | `/:id` | Super Admin, Admin | Permanently delete a patient |
| DELETE | `/soft/:id` | Super Admin, Admin | Soft delete a patient |

---

### Specialties — `/api/v1/specialties`

| Method | Endpoint | Access | Description |
|---|---|---|---|
| GET | `/` | Public | Get all medical specialties |
| POST | `/` | Super Admin, Admin | Create a new specialty with icon image upload |
| DELETE | `/:id` | Super Admin, Admin | Delete a specialty by ID |

---

### Schedules — `/api/v1/schedule`

| Method | Endpoint | Access | Description |
|---|---|---|---|
| GET | `/` | Doctor, Admin, Super Admin | Get all schedules with filtering |
| GET | `/:id` | All Roles | Get a single schedule by ID |
| POST | `/` | Super Admin, Admin | Create new appointment schedule slots |
| DELETE | `/:id` | Super Admin, Admin | Delete a schedule by ID |

---

### Doctor Schedules — `/api/v1/doctor-schedule`

| Method | Endpoint | Access | Description |
|---|---|---|---|
| GET | `/` | All Roles | Get all doctor-schedule mappings with filtering |
| GET | `/my-schedule` | Doctor | Get the authenticated doctor's own schedule |
| POST | `/` | Doctor | Book a schedule slot for the authenticated doctor |
| DELETE | `/:id` | Doctor | Remove a booked schedule slot |

---

### Appointments — `/api/v1/appointment`

| Method | Endpoint | Access | Description |
|---|---|---|---|
| GET | `/` | Super Admin, Admin | Get all appointments with filtering |
| GET | `/my-appointment` | Patient, Doctor | Get the authenticated user's appointments |
| POST | `/` | Patient | Create appointment with immediate payment (rate limited) |
| POST | `/pay-later` | Patient | Create appointment with deferred payment (30-min expiry window) |
| POST | `/:id/initiate-payment` | Patient | Initiate Stripe payment for a pay-later appointment (rate limited) |
| PATCH | `/status/:id` | Super Admin, Admin, Doctor | Update appointment status |

---

### Payments — `/api/v1/payment`

> Stripe webhook is registered directly in `app.ts` before other middleware to ensure raw request body access. This module is reserved for future payment-related routes.

---

### Prescriptions — `/api/v1/prescription`

| Method | Endpoint | Access | Description |
|---|---|---|---|
| GET | `/` | Super Admin, Admin | Get all prescriptions |
| GET | `/my-prescription` | Patient | Get the authenticated patient's prescriptions |
| POST | `/` | Doctor | Create a prescription for a completed appointment |

---

### Reviews — `/api/v1/review`

| Method | Endpoint | Access | Description |
|---|---|---|---|
| GET | `/` | Public | Get all reviews |
| POST | `/` | Patient | Submit a review for a completed appointment |

---

### Meta / Analytics — `/api/v1/meta`

| Method | Endpoint | Access | Description |
|---|---|---|---|
| GET | `/` | All Roles | Fetch role-specific dashboard analytics and metadata |

---

## ⚙️ Run Locally

### 1. Clone the repository

```bash
git clone https://github.com/ShafinRME/Cure-Wave-Server.git
cd Cure-Wave-Server
```

### 2. Install dependencies

```bash
npm install
```

### 3. Set up environment variables

Create a `.env` file in the root directory:

```env
PORT=5000
NODE_ENV=development
DATABASE_URL=your_postgresql_connection_string?sslmode=verify-full

# JWT
JWT_SECRET=your_jwt_secret
RESET_PASS_TOKEN=your_reset_pass_token
REFRESH_TOKEN_SECRET=your_refresh_token_secret
JWT_EXPIRES_IN=1d
REFRESH_TOKEN_EXPIRES_IN=7d

# Bcrypt
BCRYPT_SALT_ROUND=12

# Stripe
STRIPE_SECRET_KEY=your_stripe_secret_key
STRIPE_WEBHOOK_SECRET=your_stripe_webhook_secret

# OpenAI
OPENAI_API_KEY=your_openai_api_key

# Cloudinary
CLOUDINARY_CLOUD_NAME=your_cloud_name
CLOUDINARY_API_KEY=your_api_key
CLOUDINARY_API_SECRET=your_api_secret

# Email (Nodemailer)
SMTP_HOST=smtp.gmail.com
SMTP_PORT=465
SMTP_USER=your_email@gmail.com
SMTP_PASS=your_app_password
SMTP_FROM=your_email@gmail.com

# Frontend
FRONTEND_URL=http://localhost:3000

# Super Admin Seed
SUPER_ADMIN_EMAIL=your_super_admin_email
SUPER_ADMIN_PASSWORD=your_super_admin_password
```

### 4. Run database migrations

```bash
npm run db:generate
npm run db:push
```

### 5. Start the development server

```bash
npm run dev
```

The server will run at `http://localhost:5000`

### 6. Test Stripe webhooks locally (optional)

```bash
npm run stripe:webhook
```

---

## 🧩 Notable Implementations

- **Stripe webhook payment processing** with a pay-later flow and automatic 30-minute appointment expiry enforced via `node-cron`
- **Admin-controlled doctor onboarding** with mandatory first-login password change — platform access is blocked until credentials are properly configured
- **AI-powered doctor suggestion** using the OpenAI API with a dedicated `aiLimiter` (5 requests/min per IP) to prevent API cost abuse
- **`flexAuth` middleware** for the reset-password route — cleanly handles both first-login cookie-based flow and email-link token-based flow without inline branching logic in the router
- **Doctor profile ownership verification** in the controller — Doctors can only update their own profile; mismatched requests return `403 FORBIDDEN`
- **Patient route protection** — all patient CRUD routes are role-guarded with `auth()` middleware; Patient role includes controller-level ownership verification on read and update
- **Specialty creation protection** — `POST /specialties` restricted to Admin and Super Admin with `auth()` middleware and try/catch on Zod + JSON parsing
- **Dual soft/hard delete** pattern across all major entities (Admin, Doctor, Patient) for safe and recoverable data management
- **Role-specific dashboard metadata** served from a single `/meta` endpoint — dynamically scoped by the authenticated user's role
- **Four dedicated rate limiters** — `apiLimiter` (global, 200 req/15min), `authLimiter` (login + forgot-password, 10 req/15min), `paymentLimiter` (payment routes, 15 req/hour), `aiLimiter` (OpenAI routes, 5 req/min)
- **Multer + Cloudinary integration** for single-file image uploads on user, doctor, admin, and specialty creation
- **Zod schema validation** applied at the route level for all incoming request bodies
- **Consistent response format** across all controllers using a shared `sendResponse` utility

---

## 🔮 Future Improvements

- Run `npm audit fix` to resolve the 10 reported package vulnerabilities (8 moderate, 2 high)
- Update Prisma from `v7.6.0` to `v7.8.0` for the latest bug fixes and performance improvements
- Add downloadable PDF prescription generation for patients
- Implement OTP-based user verification for enhanced account security
- Build a real-time notification system for appointment updates and reminders
- Integrate video consultation support for remote doctor-patient sessions
- Enforce server-side pagination with Zod-validated `page` and `limit` query params on all public listing routes
- Expand Health Records, Medicines, Diagnostics, Health Plans, and NGO modules as fully dynamic features

---

## 👨‍💻 Author

**Md. Shafin Ahmed**

- GitHub: [@ShafinRME](https://github.com/ShafinRME)
- Live Project: [https://curewave.vercel.app](https://curewave.vercel.app)
