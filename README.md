<p align="center">
  <img src="assets/icon/icon.png" alt="LabMonitor Logo" width="120" style="border-radius: 50px;" />
</p>

<h1 align="center">Expenzo - Personal Expense Management App</h1>

Expenzo is a feature-rich Flutter-based mobile application designed to simplify personal expense tracking and management. With a clean UI, cloud synchronization, and real-time updates, Expenzo empowers users to stay in control of their finances effortlessly.

---

## 📱 Features

- 📊 **Expense Tracking** — Add, edit, and manage detailed expense entries.
- 🛏️ **Item Management** — Track individual items within each expense, including quantity and price.
- 🧾 **Image Attachments** — Upload and view receipts/invoices in full screen.
- 💳 **Payment Monitoring** — Track paid amounts vs. total billed.
- 🗂️ **Category Organization** — Organize expenses by custom categories (e.g., Grocery, Transport).
- 📆 **History Timeline** — Browse past expenses with a visual timeline.
- 🧹 **Responsive Design** — Seamlessly adapts to any screen size.

---

## 🔧 Tech Stack

### 🌐 Frontend

- **Flutter SDK**: `^3.7.0-323.0.dev`
- **Dart** language
- **Material Design 3** with custom theming

### 🔥 Backend & Database

- **Firebase Core** (`v3.15.1`)
- **Cloud Firestore** (`v5.6.11`) — Real-time NoSQL database

### ☁️ Cloud Storage

- **ImgBB API** — Image hosting (Free tier: 100MB, 32MB max/image)
- **Image Upload Flow**: Base64 → ImgBB → Firestore URL

### 📱 Device Integration

- `image_picker` — Camera & gallery support
- `permission_handler` — Runtime permission control
- `path_provider` — Access local file system

### 🌍 Networking

- `http` — REST API calls for image uploads

---

## 🗓️ Firestore Database Schema

### `expense` Collection

```json
{
  "id": "string",
  "date": "timestamp",
  "categoryName": "string",
  "vendorName": "string",
  "itemIds": ["string"],
  "totalBilling": "number",
  "paid": "number",
  "paymentMode": "string",
  "notes": "string",
  "imageUrls": ["string"],
  "createdAt": "timestamp"
}
```

### `items` Collection

```json
{
  "id": "string",
  "name": "string",
  "quantity": "number",
  "quantityType": "string",
  "price": "number",
  "expenseId": "string",
  "createdAt": "timestamp"
}
```

### `categories` Collection

```json
{
  "id": "string",
  "name": "string",
  "description": "string",
  "createdAt": "timestamp"
}
```

---

## 🧱 Architecture & Design Patterns

- **Service Layer Pattern**: Modular service classes for expenses, items, and categories
- **Repository Pattern**: Abstracted data layer over Firebase
- **Singleton Pattern**: Shared service instances for consistent access

### Presentation Layer

- `StatefulWidgets` for interactive screens
- `ResponsiveUtils` for adaptive UI
- Modal bottom sheets for input forms
- Full-screen PageViews for image galleries

---

## 📷 Image Upload & Viewing

- Image is picked (camera/gallery) → Encoded in Base64 → Uploaded to ImgBB
- Returned URL is saved in Firestore under the corresponding expense
- Viewer includes:
  - Zoom & Pan
  - Swipe navigation
  - Graceful error handling

---

## ⚙️ Performance Optimizations

- 🔄 **Lazy Loading**: On-demand data fetching
- 🖼️ **Image Caching**: Speeds up UI with cached assets
- 📄 **Pagination**: Efficient data rendering for large lists
- ⚡ **Optimized Rebuilds**: Minimizes widget tree rebuilds

---

## 🔒 Security & Privacy

- 🔐 Firebase security rules for document-level protection
- 🔑 API key management and abstraction
- 🛡️ Input validation for all forms
- 📁 Controlled file size and format for uploads

---

## 🚀 Dev & Deployment

- ⚡ **Hot Reload** — Instant UI updates during development
- ✅ **Linting** — Code style enforcement with `flutter_lints`
- 🎨 **Custom Icons** — Managed using `flutter_launcher_icons`
- 📱 **Cross-Platform** — Android & iOS support

---

## 📌 Summary

**Expenzo** demonstrates modern Flutter development best practices with cloud integration, responsive UI, real-time synchronization, and secure data management — making it a powerful personal finance solution.

---

## 📄 License

MIT License — Feel free to use, contribute, or modify.

---

## 🤝 Contributing

Contributions are welcome! Please open issues or submit pull requests for improvements or bug fixes.

---

## 🙌 Acknowledgements

- Flutter & Dart Team
- Firebase
- ImgBB
- Open-source plugin developers

