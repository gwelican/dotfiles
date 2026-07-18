---
name: homebox
description: Interact with Homebox inventory management system. Use when the user asks about their items, locations, labels, wants to search for things in storage, needs item details, or wants to browse their home inventory.
---

# Homebox

Interact with the Homebox inventory management instance at `$HOMEBOX_URL`.

## Prerequisites

Set these environment variables before use:

| Variable | Example |
|---|---|
| `HOMEBOX_URL` | your homebox instance URL |
| `HOMEBOX_USER` | your username |
| `HOMEBOX_PASSWORD` | your password |

## Authentication

Always authenticate first to get a bearer token, then use it for all subsequent requests:

```bash
TOKEN=$(curl -s -X POST "$HOMEBOX_URL/api/v1/users/login" \
  -H "Content-Type: application/json" \
  -d "{\"username\":\"$HOMEBOX_USER\",\"password\":\"$HOMEBOX_PASSWORD\"}" | \
  python3 -c "import sys,json; print(json.load(sys.stdin)['token'])")
```

## Available Actions

### 1. search_items — Search for items by name or description

```bash
curl -s "$HOMEBOX_URL/api/v1/items?q=QUERY" \
  -H "Authorization: $TOKEN" | python3 -m json.tool
```

- `QUERY` is a free-text search string matching item names, descriptions, and other fields.
- Returns a paginated response: `{"page": N, "pageSize": N, "total": N, "items": [...]}`
- Use `?q=` with any substring. Empty `?q=` returns all items.

### 2. get_item — Get complete details about a specific item

```bash
curl -s "$HOMEBOX_URL/api/v1/items/ITEM_ID" \
  -H "Authorization: $TOKEN" | python3 -m json.tool
```

- `ITEM_ID` is the UUID of the item.
- Returns full item details: name, description, quantity, purchase price, warranty info, purchase date, serial number, notes, location, labels, images, and timestamps.

### 3. list_locations — List all storage locations

```bash
curl -s "$HOMEBOX_URL/api/v1/locations" \
  -H "Authorization: $TOKEN" | python3 -m json.tool
```

- Returns all locations with: `id`, `name`, `description`, `itemCount`, `createdAt`, `updatedAt`.
- Locations are physical places where items are stored (e.g., "Office", "Garage", "Kitchen").

### 4. get_location — Get details about a specific location

```bash
curl -s "$HOMEBOX_URL/api/v1/locations/LOCATION_ID" \
  -H "Authorization: $TOKEN" | python3 -m json.tool
```

- `LOCATION_ID` is the UUID of the location.
- Returns location details including name, description, parent location (if nested), and metadata.

### 5. list_labels — List all labels/categories

```bash
curl -s "$HOMEBOX_URL/api/v1/labels" \
  -H "Authorization: $TOKEN" | python3 -m json.tool
```

- Returns all labels with: `id`, `name`, `description`, `createdAt`, `updatedAt`.
- Labels are used to categorize items (e.g., "Electronics", "Important", "Servers").

### 6. get_label — Get details about a specific label

```bash
curl -s "$HOMEBOX_URL/api/v1/labels/LABEL_ID" \
  -H "Authorization: $TOKEN" | python3 -m json.tool
```

- `LABEL_ID` is the UUID of the label.
- Returns label details including name, description, color, and metadata.

### 7. get_items_by_location — Get all items in a location

```bash
curl -s "$HOMEBOX_URL/api/v1/items?location=LOCATION_ID" \
  -H "Authorization: $TOKEN" | python3 -m json.tool
```

- `LOCATION_ID` is the UUID of the location.
- Returns a paginated response with all items stored in that location.
- ⚠️ Do NOT use `/api/v1/locations/:id/items` — that returns HTML (SPA fallback).

### 8. get_items_by_label — Get all items with a label

```bash
curl -s "$HOMEBOX_URL/api/v1/items?label=LABEL_ID" \
  -H "Authorization: $TOKEN" | python3 -m json.tool
```

- `LABEL_ID` is the UUID of the label.
- Returns a paginated response with all items tagged with that label.
- ⚠️ Do NOT use `/api/v1/labels/:id/items` — that returns HTML (SPA fallback).

## Quick Reference

### Current inventory snapshot

| Locations | Labels | Items |
|---|---|---|
| 8 locations | 6 labels | 3 items |
| Office, Attic, Basement, Bathroom, Bedroom, Garage, Kitchen, Living Room | Appliances, Electronics, General, IOT, Important, Servers | All 3 in Office |

### Common workflows

**Find an item:**
```bash
curl -s "$HOMEBOX_URL/api/v1/items?q=SEARCHTERM" \
  -H "Authorization: $TOKEN" | python3 -c "
import sys, json
data = json.load(sys.stdin)
for item in data.get('items', []):
    print(f'{item[\"name\"]}  [{item[\"location\"][\"name\"]}]  Qty: {item[\"quantity\"]}')
"
```

**List everything in a location:**
```bash
curl -s "$HOMEBOX_URL/api/v1/items?location=LOCATION_ID" \
  -H "Authorization: $TOKEN" | python3 -c "
import sys, json
data = json.load(sys.stdin)
for item in data.get('items', []):
    print(f'{item[\"name\"]}  Qty: {item[\"quantity\"]}  Labels: {[l[\"name\"] for l in item.get(\"labels\", [])]}')
"
```

**Get full item detail:**
```bash
curl -s "$HOMEBOX_URL/api/v1/items/ITEM_ID" \
  -H "Authorization: $TOKEN" | python3 -m json.tool
```

## Response Format

All endpoints return JSON. Key patterns:

- **List endpoints** (`/items`, `/locations`, `/labels`): Return arrays directly
- **Search** (`/items?q=...`): Returns paginated `{"page", "pageSize", "total", "items"}`
- **Single resource** (`/items/:id`, `/locations/:id`, `/labels/:id`): Returns single object
- **Sub-resources via query params**: Use `/api/v1/items?location=UUID` or `/api/v1/items?label=UUID` — NOT `/locations/:id/items` or `/labels/:id/items` (those return HTML)

Use `python3 -m json.tool` or `python3 -c "..."` to format and filter output.
