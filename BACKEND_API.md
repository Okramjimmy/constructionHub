# API Documentation

> All authenticated endpoints require a valid session cookie set by `POST /auth/login`.

---

## ENTRY API (`src/app/api/entry.py`)

Prefix: `/entry` · Tag: `ENTRY`

All endpoints return a **JSON context object** — the same data that `ui.py` passes to its Jinja2 templates, but delivered as plain JSON. Useful for AJAX / HTMX calls. All endpoints require a valid session cookie.

---

### `GET /entry/`
**Description:** Dashboard data — stage tree, visible stages, visible form types, and user permissions.

**Request:** No body. Session cookie required.

**Auth:** Any authenticated user. Only stages/form types visible to the user are returned (superadmins see everything).

**Response Fields:** `tree`, `stages`, `form_types`, `total_stages`, `total_forms`, `current_user`, `current_user_roles`, `user_permissions`

**Response Example:**
```json
{
  "tree": [...],
  "stages": [{ "stage_id": "s1", "stage_name": "Finance" }],
  "form_types": [{ "form_type_id": "ft1", "form_name": "Purchase Order" }],
  "total_stages": 3,
  "total_forms": 7,
  "current_user": { "user_id": "u1", "username": "admin" },
  "current_user_roles": ["superadmin"],
  "user_permissions": { "stages": {}, "form_types": {} }
}
```

---

### `GET /entry/stages/{stage_id}`
**Description:** Stage detail data — stage object, linked form types, child stages, breadcrumb, and all stages (for move operations).

**Request:** Path param `stage_id` (string). Session cookie required.

**Response Fields:** `stage`, `form_types`, `children`, `breadcrumb`, `all_stages`, `current_user`, `current_user_roles`, `user_permissions`

**Response Example:**
```json
{
  "stage": { "stage_id": "s1", "stage_name": "Finance" },
  "form_types": [...],
  "children": [...],
  "breadcrumb": [...],
  "all_stages": [...],
  "current_user": { "user_id": "u1", "username": "admin" },
  "current_user_roles": ["superadmin"],
  "user_permissions": {}
}
```

---

### `GET /entry/form-builder/new/{stage_id}`
**Description:** Context for creating a brand-new form type, optionally scoped to a stage.

**Request:** Path param `stage_id` (string, or `"standalone"` for no stage). Session cookie required.

**Response Fields:** `form_type` (null), `stage`, `current_user`, `current_user_roles`

**Response Example:**
```json
{
  "form_type": null,
  "stage": { "stage_id": "s1", "stage_name": "Finance" },
  "current_user": { "user_id": "u1", "username": "admin" },
  "current_user_roles": ["superadmin"]
}
```

---

### `GET /entry/form-builder/{form_type_id}`
**Description:** Context for editing an existing form type's schema.

**Request:** Path param `form_type_id` (string). Session cookie required.

**Response Fields:** `form_type`, `stage`, `current_user`, `current_user_roles`, `user_permissions`

**Response Example:**
```json
{
  "form_type": { "form_type_id": "ft1", "form_name": "Purchase Order" },
  "stage": { "stage_id": "s1", "stage_name": "Finance" },
  "current_user": { "user_id": "u1", "username": "admin" },
  "current_user_roles": ["superadmin"],
  "user_permissions": {}
}
```

---

### `GET /entry/workflow-builder/{form_type_id}`
**Description:** Context for editing a form type's workflow. Includes a `can_edit` flag and the full list of roles for the assignee dropdown.

**Request:** Path param `form_type_id` (string). Session cookie required.

**Response Fields:** `form_type`, `stage`, `current_user`, `current_user_roles`, `user_permissions`, `can_edit`, `all_roles`

**Notes:**
- `can_edit` is `true` for superadmins, or when the user has edit permission on the form type.
- `all_roles` is the raw list of role objects.

**Response Example:**
```json
{
  "form_type": { "form_type_id": "ft1", "form_name": "Purchase Order" },
  "stage": { "stage_id": "s1", "stage_name": "Finance" },
  "current_user": { "user_id": "u1", "username": "admin" },
  "current_user_roles": ["superadmin"],
  "user_permissions": {},
  "can_edit": true,
  "all_roles": [{ "role_name": "manager" }]
}
```

---

### `GET /entry/forms/{form_type_id}/new`
**Description:** Context for rendering an empty (new) form record.

**Request:** Path param `form_type_id` (string). Session cookie required.

**Response Fields:** `form_type`, `stage`, `record` (null), `current_user`, `current_user_roles`, `user_permissions`

**Response Example:**
```json
{
  "form_type": { "form_type_id": "ft1", "form_name": "Purchase Order" },
  "stage": { "stage_id": "s1" },
  "record": null,
  "current_user": { "user_id": "u1" },
  "current_user_roles": ["manager"],
  "user_permissions": {}
}
```

---

### `GET /entry/forms/{form_type_id}/{record_id}`
**Description:** Context for viewing or editing an existing form record.

**Request:** Path params `form_type_id`, `record_id` (strings). Session cookie required.

**Response Fields:** `form_type`, `stage`, `record`, `current_user`, `current_user_roles`, `user_permissions`

**Response Example:**
```json
{
  "form_type": { "form_type_id": "ft1", "form_name": "Purchase Order" },
  "stage": { "stage_id": "s1" },
  "record": { "record_id": "r1", "status": "Draft", "data": {} },
  "current_user": { "user_id": "u1" },
  "current_user_roles": ["manager"],
  "user_permissions": {}
}
```

---

### `GET /entry/forms/{form_type_id}`
**Description:** Context for the form records list view — returns paginated records (hard limit 100) and total count.

**Request:** Path param `form_type_id` (string). Session cookie required.

**Response Fields:** `form_type`, `stage`, `records`, `total`, `current_user`, `current_user_roles`, `user_permissions`

**Response Example:**
```json
{
  "form_type": { "form_type_id": "ft1", "form_name": "Purchase Order" },
  "stage": { "stage_id": "s1" },
  "records": [...],
  "total": 25,
  "current_user": { "user_id": "u1" },
  "current_user_roles": ["manager"],
  "user_permissions": {}
}
```

---

### `GET /entry/forms`
**Description:** Context for the main forms listing page. Returns all form types visible to the user.

**Request:** No body. Session cookie required.

**Auth:** Superadmins see all form types; regular users see only form types linked to their visible stages.

**Response Fields:** `current_user`, `current_user_roles`, `form_types`, `user_permissions`

**Response Example:**
```json
{
  "current_user": { "user_id": "u1", "username": "admin" },
  "current_user_roles": ["superadmin"],
  "form_types": [...],
  "user_permissions": {}
}
```

---

### `GET /entry/permissions`
**Description:** Context for the permissions management page. **Superadmin only.**

**Request:** No body. Session cookie required.

**Auth:** Superadmin only — returns `404` for non-superadmin users.

**Response Fields:** `stages` (JSON-serialised list), `form_types` (JSON-serialised list), `current_user`, `current_user_roles`

**Response Example:**
```json
{
  "stages": [{ "stage_id": "s1", "stage_name": "Finance" }],
  "form_types": [{ "form_type_id": "ft1", "form_name": "Purchase Order" }],
  "current_user": { "user_id": "u1" },
  "current_user_roles": ["superadmin"]
}
```

---

### `GET /entry/roles`
**Description:** Context for the roles management page. **Superadmin only.**

**Request:** No body. Session cookie required.

**Auth:** Superadmin only — returns `404` for non-superadmin users.

**Response Fields:** `stages`, `form_types`, `current_user`, `current_user_roles`

**Response Example:**
```json
{
  "stages": [...],
  "form_types": [...],
  "current_user": { "user_id": "u1" },
  "current_user_roles": ["superadmin"]
}
```

---

### `GET /entry/profile`
**Description:** Current user's profile data, including a time-limited presigned URL for their profile photo.

**Request:** No body. Session cookie required.

**Response Fields:** `current_user`, `current_user_roles`, `photo_url`

**Notes:** `photo_url` is a presigned MinIO URL valid for 1 hour, or `null` if no photo is set.

**Response Example:**
```json
{
  "current_user": { "user_id": "u1", "username": "admin", "full_name": "Admin User" },
  "current_user_roles": ["superadmin"],
  "photo_url": "https://minio.example.com/bucket/users/u1/photo.jpg?X-Amz-Signature=..."
}
```

---

### `GET /entry/users`
**Description:** User management data including all users with their roles and all available roles. **Superadmin only.**

**Request:** No body. Session cookie required.

**Auth:** Superadmin only — returns `404` for non-superadmin users.

**Response Fields:** `current_user`, `current_user_roles`, `users`, `all_roles`

**Notes:** Each item in `users` is the user's dict (`to_dict()`) merged with a `roles` field.

**Response Example:**
```json
{
  "current_user": { "user_id": "u1" },
  "current_user_roles": ["superadmin"],
  "users": [{ "user_id": "u2", "username": "john", "roles": ["manager"] }],
  "all_roles": [{ "role_name": "manager" }]
}
```

---

## V1 API (`src/app/api/v1`)

### 1. Auth — `POST /auth/login`
**Description:** Authenticate with username and password. Sets an HTTP-only session cookie.

**Request Format:**
```json
{
  "username": "string",
  "password": "string"
}
```
**Request Example:**
```json
{ "username": "admin", "password": "Secret@123" }
```

**Response Format:**
```json
{
  "user_id": "string",
  "username": "string",
  "email": "string",
  "full_name": "string",
  "department": "string | null",
  "phone": "string | null",
  "manager_id": "string | null",
  "profile_photo_url": "string | null",
  "is_active": true,
  "created_at": "datetime",
  "updated_at": "datetime",
  "roles": ["string"]
}
```
**Response Example:**
```json
{
  "user_id": "u1",
  "username": "admin",
  "email": "admin@example.com",
  "full_name": "Admin User",
  "department": "IT",
  "phone": null,
  "manager_id": null,
  "profile_photo_url": null,
  "is_active": true,
  "created_at": "2025-01-01T00:00:00",
  "updated_at": "2025-01-01T00:00:00",
  "roles": ["superadmin"]
}
```

---

### `POST /auth/logout`
**Description:** Clear the session cookie.

**Request:** No body required.

**Response:** `204 No Content`

---

### `GET /auth/me`
**Description:** Return the currently authenticated user with their roles.

**Request:** No body. Session cookie required.

**Response Format:** Same as `POST /auth/login` response.

**Response Example:**
```json
{
  "user_id": "u1",
  "username": "admin",
  "email": "admin@example.com",
  "full_name": "Admin User",
  "roles": ["superadmin"]
}
```

---

### 2. Form Records — `POST /form-records`
**Description:** Create a new form record.

**Request Format:**
```json
{
  "form_type_id": "string",
  "data": { "field_name": "value" }
}
```
**Request Example:**
```json
{
  "form_type_id": "ft1",
  "data": { "item_name": "Laptop", "quantity": 2 }
}
```

**Response Format:**
```json
{
  "record_id": "string",
  "form_type_id": "string",
  "docname": "string",
  "status": "string",
  "assigned_role": "string | null",
  "assigned_department": "string | null",
  "data": {},
  "amended_from": "string | null",
  "submitted_by": "string | null",
  "submitted_at": "datetime | null",
  "created_by": "string | null",
  "created_at": "datetime",
  "updated_at": "datetime"
}
```
**Response Example:**
```json
{
  "record_id": "r1",
  "form_type_id": "ft1",
  "docname": "PO-2025-001",
  "status": "Draft",
  "assigned_role": null,
  "data": { "item_name": "Laptop", "quantity": 2 },
  "created_by": "u1",
  "created_at": "2025-01-01T10:00:00",
  "updated_at": "2025-01-01T10:00:00"
}
```

---

### `GET /form-records?form_type_id={id}`
**Description:** List records filtered by form type.

**Request Query Params:** `form_type_id` (required), `skip` (default 0), `limit` (default 50, max 200)

**Request Example:** `GET /form-records?form_type_id=ft1&skip=0&limit=10`

**Response Format:**
```json
{
  "items": [ { "record_id": "...", "status": "...", "data": {} } ],
  "total": 25
}
```

---

### `GET /form-records/{record_id}`
**Description:** Get a single record by ID.

**Request:** Path param `record_id`.

**Response Format:** Same as `FormRecordResponse` above.

---

### `PUT /form-records/{record_id}`
**Description:** Update a form record's data.

**Request Format:**
```json
{ "data": { "field_name": "updated_value" } }
```
**Request Example:**
```json
{ "data": { "item_name": "Laptop Pro", "quantity": 3 } }
```

**Response Format:** Same as `FormRecordResponse`.

---

### `GET /form-records/{record_id}/available-actions`
**Description:** Get valid transition triggers for the current user and record state.

**Request:** Path param `record_id`. Session cookie required.

**Response Format:**
```json
["string"]
```
**Response Example:**
```json
["submit", "cancel"]
```

---

### `POST /form-records/{record_id}/transition`
**Description:** Execute a state machine transition on a record.

**Request Format:**
```json
{
  "trigger": "string",
  "remarks": "string (optional)"
}
```
**Request Example:**
```json
{ "trigger": "submit", "remarks": "Reviewed and approved." }
```

**Response Format:** Same as `FormRecordResponse`.

---

### `POST /form-records/{record_id}/upload-attachment`
**Description:** Upload a file for an Attach field. Uses `multipart/form-data`.

**Request Fields:** `file` (binary), `field_name` (form string)

**Request Example (curl):**
```bash
curl -X POST /form-records/r1/upload-attachment \
  -F "field_name=invoice_file" \
  -F "file=@invoice.pdf"
```

**Response Format:** Same as `FormRecordResponse` with `data[field_name]` containing the stored filename.

---

### `DELETE /form-records/{record_id}`
**Description:** Delete a form record.

**Request:** Path param `record_id`. Session cookie required.

**Response:** `204 No Content`

---

### 3. Form Types — `POST /form-types`
**Description:** Create a new form type. Superadmin only.

**Request Format:**
```json
{
  "form_name": "string",
  "description": "string (optional)",
  "version": "string (e.g. 1.0.0)",
  "schema": { "fields": [] },
  "workflow_data": {}
}
```
**Request Example:**
```json
{
  "form_name": "Purchase Order",
  "description": "Used for procurement",
  "version": "1.0.0",
  "schema": { "fields": [{ "name": "item_name", "type": "text" }] }
}
```

**Response Format:**
```json
{
  "form_type_id": "string",
  "form_name": "string",
  "description": "string | null",
  "version": "string",
  "schema_reference": {},
  "workflow_data": {},
  "created_by": "string | null",
  "created_at": "datetime",
  "updated_at": "datetime"
}
```
**Response Example:**
```json
{
  "form_type_id": "ft1",
  "form_name": "Purchase Order",
  "description": "Used for procurement",
  "version": "1.0.0",
  "schema_reference": { "fields": [{ "name": "item_name", "type": "text" }] },
  "workflow_data": null,
  "created_by": "u1",
  "created_at": "2025-01-01T00:00:00",
  "updated_at": "2025-01-01T00:00:00"
}
```

---

### `POST /form-types/{form_type_id}/link-stage/{stage_id}`
**Description:** Link a form type to a stage.

**Request:** No body. Path params `form_type_id`, `stage_id`.

**Response Example:**
```json
{ "form_type_id": "ft1", "stage_id": "s1", "linked_by": "u1" }
```

---

### `DELETE /form-types/{form_type_id}/link-stage/{stage_id}`
**Description:** Unlink a form type from a stage.

**Request:** No body. Path params `form_type_id`, `stage_id`.

**Response Example:**
```json
{ "detail": "Unlinked successfully" }
```

---

### `GET /form-types`
**Description:** List all form types.

**Request Query Params:** `skip` (default 0), `limit` (default 50, max 1000)

**Response Example:**
```json
[
  {
    "form_type_id": "ft1",
    "form_name": "Purchase Order",
    "version": "1.0.0",
    "created_at": "2025-01-01T00:00:00",
    "updated_at": "2025-01-01T00:00:00"
  }
]
```

---

### `GET /form-types/with-schema`
**Description:** List form types including their full schema data.

**Request Query Params:** `skip`, `limit`

**Response Example:**
```json
[
  {
    "form_type_id": "ft1",
    "form_name": "Purchase Order",
    "schema_reference": { "fields": [] },
    "version": "1.0.0"
  }
]
```

---

### `GET /form-types/search?q={query}`
**Description:** Search form types by name.

**Request Query Params:** `q` (required), `limit`

**Response Example:**
```json
[{ "form_type_id": "ft1", "form_name": "Purchase Order", "version": "1.0.0" }]
```

---

### `GET /form-types/stage/{stage_id}`
**Description:** Get all form types linked to a stage.

**Request:** Path param `stage_id`. Query params `skip`, `limit`.

**Response Example:** Array of `FormTypeResponse` objects.

---

### `GET /form-types/{form_type_id}`
**Description:** Get a specific form type by ID.

**Response Example:**
```json
{
  "form_type_id": "ft1",
  "form_name": "Purchase Order",
  "version": "1.0.0",
  "schema_reference": null
}
```

---

### `GET /form-types/{form_type_id}/schema`
**Description:** Get form type with full schema data.

**Response Example:**
```json
{
  "form_type_id": "ft1",
  "form_name": "Purchase Order",
  "version": "1.0.0",
  "schema_reference": { "fields": [{ "name": "item_name", "type": "text" }] }
}
```

---

### `PUT /form-types/{form_type_id}`
**Description:** Update a form type.

**Request Format:**
```json
{
  "form_name": "string (optional)",
  "version": "string (optional)",
  "schema": {},
  "workflow_data": {}
}
```
**Request Example:**
```json
{ "form_name": "Updated PO Form", "version": "1.0.1" }
```

**Response Format:** Same as `FormTypeResponse`.

---

### `DELETE /form-types/{form_type_id}`
**Description:** Delete a form type.

**Response Example:**
```json
{ "detail": "FormType ft1 deleted successfully" }
```

---

### 4. Metadata — `GET /metadata/master`
**Description:** Get the master metadata tree.

**Request Query Params:** `force` (bool, default false — forces regeneration from DB)

**Response Example:**
```json
{
  "version": "1.0",
  "generated_at": "2025-01-01T00:00:00",
  "statistics": { "total_stages": 5, "total_form_types": 12 },
  "tree": [{ "stage_id": "s1", "stage_name": "Finance", "children": [] }]
}
```

---

### `GET /metadata/registry`
**Description:** Flat O(1) lookup index for stages and form types.

**Request Query Params:** `force` (bool, default false)

**Response Example:**
```json
{
  "stages": { "s1": { "stage_name": "Finance", "depth_level": 0 } },
  "form_types": { "ft1": { "form_name": "Purchase Order" } }
}
```

---

### `GET /metadata/stages/{stage_id}`
**Description:** Get metadata for a specific stage.

**Response Example:**
```json
{
  "stage_id": "s1",
  "stage_name": "Finance",
  "depth_level": 0,
  "form_types": [{ "form_type_id": "ft1", "form_name": "Purchase Order" }]
}
```

---

### `POST /metadata/regenerate`
**Description:** Regenerate all master metadata and registry.

**Request:** No body.

**Response Example:**
```json
{ "detail": "Metadata regenerated successfully", "generated_at": "2025-01-01T00:00:00" }
```

---

### `GET /metadata/validate`
**Description:** Validate metadata consistency against the database.

**Response Example:**
```json
{
  "valid": true,
  "issues": [],
  "checked_stages": 5,
  "checked_form_types": 12
}
```

---

### `GET /metadata/statistics`
**Description:** Get statistics about the current metadata state.

**Response Example:**
```json
{
  "stages": { "total_stages": 5, "root_stages": 2, "leaf_stages": 3 },
  "provider": { "version": "1.0", "generated_at": "2025-01-01T00:00:00" }
}
```

---

### 5. Permissions — `POST /permissions/stages/{stage_id}`
**Description:** Grant stage permissions to a role.

**Request Format:**
```json
{
  "role_name": "string",
  "can_view": false,
  "can_create": false,
  "can_edit": false,
  "can_delete": false,
  "can_manage_permissions": false
}
```
**Request Example:**
```json
{ "role_name": "manager", "can_view": true, "can_create": true, "can_edit": true }
```

**Response Format:**
```json
{
  "permission_id": 1,
  "stage_id": "string",
  "role_name": "string",
  "can_view": true,
  "can_create": true,
  "can_edit": true,
  "can_delete": false,
  "can_manage_permissions": false,
  "granted_by": "string | null",
  "granted_at": "datetime"
}
```

---

### `DELETE /permissions/stages/{stage_id}/roles/{role_name}`
**Description:** Revoke a role's permissions for a stage.

**Response Example:**
```json
{ "detail": "Permission for role 'manager' on stage 's1' revoked." }
```

---

### `GET /permissions/stages/{stage_id}`
**Description:** Get all permissions for a stage and its linked form types.

**Response Example:**
```json
{
  "stage_permissions": [
    { "permission_id": 1, "stage_id": "s1", "role_name": "manager", "can_view": true }
  ],
  "form_type_permissions": [
    { "permission_id": 2, "form_type_id": "ft1", "role_name": "manager", "can_create": true }
  ]
}
```

---

### `POST /permissions/form-types/{form_type_id}`
**Description:** Grant form type permissions to a role.

**Request Format:**
```json
{
  "role_name": "string",
  "can_view": false,
  "can_create": false,
  "can_edit": false,
  "can_delete": false,
  "can_submit": false,
  "can_verify": false,
  "can_cancel": false,
  "can_amend": false,
  "can_manage_permissions": false
}
```
**Request Example:**
```json
{ "role_name": "manager", "can_view": true, "can_create": true, "can_submit": true }
```

**Response Format:**
```json
{
  "permission_id": 1,
  "form_type_id": "string",
  "role_name": "string",
  "can_view": true,
  "can_create": true,
  "can_edit": false,
  "can_delete": false,
  "can_submit": true,
  "can_verify": false,
  "can_cancel": false,
  "can_amend": false,
  "can_manage_permissions": false,
  "granted_by": "string | null",
  "granted_at": "datetime"
}
```

---

### `DELETE /permissions/form-types/{form_type_id}/roles/{role_name}`
**Description:** Revoke a role's form type permissions.

**Response Example:**
```json
{ "detail": "Permission for role 'manager' on form type 'ft1' revoked." }
```

---

### `POST /permissions/users/roles`
**Description:** Assign a role to a user.

**Request Format:**
```json
{ "user_id": "string", "role_name": "string" }
```
**Request Example:**
```json
{ "user_id": "u2", "role_name": "manager" }
```

**Response Example:**
```json
{ "user_id": "u2", "role_name": "manager", "assigned_at": "2025-01-01T00:00:00" }
```

---

### `POST /permissions/roles`
**Description:** Create a new role.

**Request Format:**
```json
{ "role_name": "string (lowercase, alphanumeric, underscores)", "description": "string (optional)" }
```
**Request Example:**
```json
{ "role_name": "finance_manager", "description": "Manages finance forms" }
```

**Response Example:**
```json
{ "role_name": "finance_manager", "description": "Manages finance forms", "created_at": "2025-01-01T00:00:00" }
```

---

### `GET /permissions/users/{user_id}/roles`
**Description:** Get all roles assigned to a user.

**Response Example:**
```json
{ "user_id": "u1", "roles": ["superadmin", "manager"] }
```

---

### `GET /permissions/users/{user_id}/accessible-stages`
**Description:** Get all stages and form types accessible to a user.

**Response Example:**
```json
{
  "accessible_stage_ids": ["s1", "s2"],
  "accessible_form_type_ids": ["ft1"],
  "total_count": 3
}
```

---

### `GET /permissions/users/{user_id}/check-stage/{stage_id}`
**Description:** Check if user has a specific permission on a stage.

**Request Query Params:** `permission_type` (one of: `can_view`, `can_create`, `can_edit`, `can_delete`, `can_manage_permissions`)

**Response Example:**
```json
{
  "user_id": "u1",
  "stage_id": "s1",
  "permission_type": "can_edit",
  "has_permission": true
}
```

---

### `GET /permissions/stages`
**Description:** List all stage permissions, optionally filtered by role.

**Request Query Params:** `role_name` (optional)

**Response Example:**
```json
[{ "permission_id": 1, "stage_id": "s1", "role_name": "manager", "can_view": true }]
```

---

### `GET /permissions/form-types`
**Description:** List all form type permissions, optionally filtered by role.

**Request Query Params:** `role_name` (optional)

**Response Example:**
```json
[{ "permission_id": 2, "form_type_id": "ft1", "role_name": "manager", "can_submit": true }]
```

---

### `GET /permissions/roles/{role_name}`
**Description:** Get all permissions for a role.

**Response Example:**
```json
{
  "role_name": "manager",
  "stage_permissions": [...],
  "form_type_permissions": [...]
}
```

---

### `GET /permissions/roles`
**Description:** List all roles.

**Response Example:**
```json
[{ "role_name": "manager", "description": "Department manager" }]
```

---

### `DELETE /permissions/roles/{role_name}`
**Description:** Delete a role and all associated permissions.

**Response Example:**
```json
{ "detail": "Role 'manager' and all associated permissions deleted." }
```

---

### `PUT /permissions/roles/{old_role_name}?new_role_name={name}`
**Description:** Rename a role.

**Response Example:**
```json
{ "old_role_name": "manager", "new_role_name": "dept_manager" }
```

---

### 6. Stages — `POST /stages`
**Description:** Create a new stage.

**Request Format:**
```json
{
  "stage_name": "string",
  "parent_stage_id": "string | null",
  "visibility_scope": "public | private | restricted",
  "wbs_prefix": "string (optional, alphanumeric, max 10)"
}
```
**Request Example:**
```json
{ "stage_name": "Finance", "parent_stage_id": null, "visibility_scope": "private" }
```

**Response Format:**
```json
{
  "stage_id": "string",
  "stage_name": "string",
  "parent_stage_id": "string | null",
  "stage_path": "string",
  "depth_level": 0,
  "lineage_path": ["string"],
  "children_count": 0,
  "formtype_count": 0,
  "is_root": true,
  "is_leaf": true,
  "visibility_scope": "private",
  "wbs_prefix": "string | null",
  "created_by": "string | null",
  "created_at": "datetime",
  "updated_at": "datetime"
}
```
**Response Example:**
```json
{
  "stage_id": "s1",
  "stage_name": "Finance",
  "parent_stage_id": null,
  "stage_path": "Finance",
  "depth_level": 0,
  "lineage_path": ["s1"],
  "children_count": 0,
  "formtype_count": 0,
  "is_root": true,
  "is_leaf": true,
  "visibility_scope": "private",
  "created_by": "u1",
  "created_at": "2025-01-01T00:00:00",
  "updated_at": "2025-01-01T00:00:00"
}
```

---

### `GET /stages`
**Description:** List all stages.

**Request Query Params:** `skip` (default 0), `limit` (default 50, max 100)

**Response Example:**
```json
[{ "stage_id": "s1", "stage_name": "Finance", "depth_level": 0 }]
```

---

### `GET /stages/tree`
**Description:** Get hierarchical stage tree.

**Request Query Params:** `root_stage_id`, `max_depth`, `user_id` (all optional)

**Response Example:**
```json
[
  {
    "stage_id": "s1",
    "stage_name": "Finance",
    "depth_level": 0,
    "children": [{ "stage_id": "s2", "stage_name": "Accounts Payable" }],
    "form_types": [{ "form_type_id": "ft1", "form_name": "Purchase Order" }]
  }
]
```

---

### `GET /stages/search?q={query}`
**Description:** Search stages by name.

**Response Example:**
```json
[{ "stage_id": "s1", "stage_name": "Finance", "depth_level": 0 }]
```

---

### `GET /stages/{stage_id}`
**Description:** Get a specific stage by ID.

**Response Example:** Same as `StageResponse` above.

---

### `PUT /stages/{stage_id}`
**Description:** Update a stage.

**Request Format:**
```json
{
  "stage_name": "string (optional)",
  "visibility_scope": "public | private | restricted (optional)",
  "wbs_prefix": "string (optional)"
}
```
**Request Example:**
```json
{ "stage_name": "Finance & Accounts", "visibility_scope": "public" }
```

**Response Format:** Same as `StageResponse`.

---

### `POST /stages/{stage_id}/move`
**Description:** Move a stage to a new parent.

**Request Format:**
```json
{
  "target_parent_id": "string",
  "options": { "update_lineage": true, "update_master_metadata": true }
}
```
**Request Example:**
```json
{ "target_parent_id": "s3" }
```

**Response Example:**
```json
{
  "stage_id": "s1",
  "old_path": "Finance",
  "new_path": "Operations/Finance",
  "affected_stages_count": 3,
  "operation_duration_ms": 45.2,
  "moved_stages": [
    { "stage_id": "s1", "old_name": "Finance", "new_name": "Finance", "old_path": "Finance", "new_path": "Operations/Finance" }
  ]
}
```

---

### `DELETE /stages/{stage_id}`
**Description:** Delete a stage (and descendants if recursive=true).

**Request Query Params:** `recursive` (bool, default true), `preview` (bool, default false)

**Response Example:**
```json
{
  "deleted_stages": ["s1", "s2"],
  "deleted_form_types": ["ft1"],
  "total_deleted": 3
}
```

---

### `GET /stages/{stage_id}/permissions`
**Description:** Get resolved permissions of the current user for a stage.

**Response Example:**
```json
{
  "stage_id": "s1",
  "permissions": {
    "stage": { "view": true, "create": true, "edit": false, "delete": false, "manage_permissions": false },
    "form_types": {
      "ft1": { "view": true, "create": true, "edit": true, "delete": false, "submit": true }
    }
  }
}
```

---

### 7. Storage — `POST /upload`
**Description:** Upload a file to MinIO storage.

**Request Format:** `multipart/form-data` with `file` (binary) and optional `path` (string).

**Request Example (curl):**
```bash
curl -X POST /upload -F "file=@report.pdf" -F "path=documents/"
```

**Response Example:**
```json
{
  "status": "success",
  "message": "File uploaded successfully",
  "object_name": "documents/report.pdf",
  "size": 204800,
  "content_type": "application/pdf"
}
```

---

### `GET /list/{prefix}`
**Description:** List files in MinIO matching a path prefix.

**Request:** Path param `prefix` (string path).

**Response Example:**
```json
{ "files": ["documents/report.pdf", "documents/invoice.pdf"] }
```

---

### `GET /download/{formtype_id}/{form_record_id}/{field_name}/{file_name}`
**Description:** Download a file via a presigned URL redirect.

**Request:** Path params for entity identification, query param `download` (0 = inline, 1 = attachment).

**Response:** `307 Temporary Redirect` to a signed MinIO URL.

---

### `DELETE /delete/{file_name}`
**Description:** Delete a file from MinIO.

**Request:** Path param `file_name` (full path).

**Response Example:**
```json
{
  "status": "success",
  "message": "File deleted successfully",
  "object_name": "documents/report.pdf"
}
```

---

### `GET /list`
**Description:** List files with optional query prefix filter.

**Request Query Params:** `prefix` (optional string)

**Response Example:**
```json
{
  "status": "success",
  "bucket": "erp-bucket",
  "prefix": "documents/",
  "file_count": 2,
  "files": ["documents/report.pdf", "documents/invoice.pdf"]
}
```

---

### `GET /url/{file_name}`
**Description:** Generate a presigned URL for a file.

**Request:** Path param `file_name`, query param `expires_hours` (default 1).

**Response Example:**
```json
{
  "status": "success",
  "url": "https://minio.example.com/bucket/documents/report.pdf?X-Amz-Signature=...",
  "expires_in_hours": 1,
  "object_name": "documents/report.pdf"
}
```

---

### 8. Users — `GET /users`
**Description:** List all users with roles. Superadmins see all; others see non-superadmin users.

**Request Query Params:** `skip` (default 0), `limit` (default 50, max 200)

**Response Example:**
```json
[
  {
    "user_id": "u1",
    "username": "admin",
    "email": "admin@example.com",
    "full_name": "Admin User",
    "department": "IT",
    "is_active": true,
    "roles": ["superadmin"]
  }
]
```

---

### `POST /users`
**Description:** Create a new user. Superadmin only.

**Request Format:**
```json
{
  "username": "string (min 3)",
  "email": "valid email",
  "full_name": "string",
  "password": "string (min 8, needs uppercase, digit, special char)",
  "department": "string (optional)",
  "phone": "string (optional)",
  "manager_id": "string (optional)",
  "roles": ["string"] 
}
```
**Request Example:**
```json
{
  "username": "john_doe",
  "email": "john@example.com",
  "full_name": "John Doe",
  "password": "Secret@123",
  "department": "Finance"
}
```

**Response Format:**
```json
{
  "user_id": "string",
  "username": "string",
  "email": "string",
  "full_name": "string",
  "department": "string | null",
  "phone": "string | null",
  "is_active": true,
  "created_at": "datetime",
  "updated_at": "datetime",
  "roles": []
}
```

---

### `GET /users/{user_id}`
**Description:** Get a user by ID. Users can only fetch themselves; superadmins can fetch any.

**Response Format:** Same as `UserResponse`.

---

### `PUT /users/{user_id}`
**Description:** Update profile fields. Self or superadmin only.

**Request Format:**
```json
{
  "full_name": "string (optional)",
  "email": "email (optional)",
  "department": "string (optional)",
  "phone": "string (optional)"
}
```
**Request Example:**
```json
{ "full_name": "John A. Doe", "phone": "+1234567890" }
```

**Response Format:** Same as `UserResponse`.

---

### `PUT /users/{user_id}/password`
**Description:** Change a user's own password.

**Request Format:**
```json
{
  "current_password": "string",
  "password": "string (new, min 8)",
  "confirm_password": "string (must match password)"
}
```
**Request Example:**
```json
{
  "current_password": "OldPass@1",
  "password": "NewPass@2",
  "confirm_password": "NewPass@2"
}
```

**Response:** `204 No Content`

---

### `PUT /users/{user_id}/status?is_active={bool}`
**Description:** Activate or deactivate a user. Superadmin only.

**Request Query Param:** `is_active` (bool)

**Response Format:** Same as `UserResponse`.

---

### `POST /users/{user_id}/photo`
**Description:** Upload a profile photo. Allowed types: JPEG, JPG, PNG, GIF, WebP.

**Request Format:** `multipart/form-data` with `file` (image binary).

**Response Format:** Same as `UserResponse` with `profile_photo_url` set to the MinIO key.

---

### `GET /users/{user_id}/photo`
**Description:** Get a 1-hour presigned URL for the user's profile photo.

**Response Example:**
```json
{
  "url": "https://minio.example.com/bucket/users/u1_it/photo.jpg?X-Amz-Signature=...",
  "key": "users/u1_it/photo.jpg"
}
```

---

### `GET /users/{user_id}/roles`
**Description:** Get all roles for a user.

**Response Example:**
```json
{ "user_id": "u1", "roles": ["superadmin", "manager"] }
```

---

### `POST /users/{user_id}/roles`
**Description:** Assign one or more roles to a user (idempotent). Superadmin only.

**Request Format:** JSON array of role name strings.

**Request Example:**
```json
["manager", "viewer"]
```

**Response Example:**
```json
{ "user_id": "u1", "roles": ["superadmin", "manager", "viewer"] }
```

---

### `DELETE /users/{user_id}/roles/{role_name}`
**Description:** Revoke a single role from a user. Superadmin only.

**Response Example:**
```json
{ "user_id": "u1", "revoked": "viewer", "remaining": ["superadmin", "manager"] }
```
