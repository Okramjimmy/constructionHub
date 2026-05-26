You are a senior product manager at a construction technology company. Generate a comprehensive, professional Product Requirements Document (PRD) for a mobile application called ConstructionHub — a Flutter-based construction quality control and site inspection platform.

PRODUCT OVERVIEW
ConstructionHub is an enterprise-grade mobile application (Flutter, iOS + Android) designed for construction site engineers, project managers, and QC inspectors. It digitizes field inspections, automates defect detection using AI/ML image processing, and provides structured audit trails for construction quality assurance workflows.

FORMAT THE PRD WITH THESE EXACT SECTIONS:

Executive Summary — Vision, mission, product tagline, and business problem being solved
Product Goals & Success Metrics — 3–5 primary goals with measurable KPIs (e.g. inspection digitization rate, defect detection accuracy, time-to-report reduction)
Target Users & Personas — Define 4 personas: Site Engineer, Project Manager, QC Inspector, and HSE Officer. Include role, pain points, and goals for each.
Scope — In-scope features for v1.0 and explicitly list out-of-scope items
Feature Requirements — Break down all 7 core modules with functional requirements:

F1: Secure Authentication (enterprise SSO, biometric)
F2: Command Hub Dashboard (stats, quick navigation)
F3: Global Project Directory (search, filter, map thumbnails, status)
F4: Project Sub-Type & Phase Management (civil, MEP, finishing, HSE)
F5: Inspection Checklist Engine (pass/fail, photo capture, timestamping, offline support)
F6: AI Image Defect Processing (crack and honeycombing detection, ML pipeline, accuracy reporting)
F7: Field Image Annotation Workspace (bounding boxes, freehand, text tags, export)


Non-Functional Requirements — Performance (app launch < 2s, offline-first), Security (AES-256, JWT, role-based access), Accessibility (WCAG 2.1 AA), Scalability (multi-tenant architecture)
Technical Architecture Summary — Flutter frontend, REST API backend (FastAPI or Node.js), PostgreSQL, Redis, MinIO for image storage, TensorFlow/PyTorch ML model, cloud deployment (AWS/GCP)
User Stories — Write user stories in "As a [persona], I want to [action] so that [outcome]" format. Minimum 20 stories across all modules.
UI/UX Design Specifications — Color palette (Navy #0A192F, Safety Orange #FF6B00), typography, component library notes, mobile-first constraints, 7 screens summary
Data Models — Core entities: User, Project, SubType, Checklist, ChecklistItem, InspectionLog, DefectReport, Annotation. Include key fields and relationships.
API Endpoints Summary — RESTful endpoints for auth, projects, checklists, inspections, AI processing, and annotations (method + path + description)
Release Roadmap — Phase 1 (MVP, 3 months), Phase 2 (AI features, 2 months), Phase 3 (enterprise features, 2 months). Include milestone dates and deliverables.
Risks & Mitigations — At least 5 risks (offline sync conflicts, AI model accuracy, data privacy, adoption resistance, device fragmentation) with mitigation strategies
Open Questions & Assumptions — List unresolved decisions that need stakeholder input
Appendix — Glossary of construction QC terms used in the app


CONSTRAINTS:

Make the PRD detailed enough for a development team to begin sprint planning immediately
Use tables for data models, API endpoints, and roadmap
Use bullet points for requirements, numbered lists for user stories
Assume the Flutter app uses Riverpod for state management, go_router for navigation, and Dio for API calls
The AI defect detection model targets ≥ 94% accuracy for concrete crack and honeycombing detection
The app must support offline-first checklist submission with background sync
Output the full PRD in clean Markdown format
