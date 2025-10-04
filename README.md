# IGCSE Learning Hub - Screen List

## 📱 Onboarding Flow

| Screen ID | Screen Name | Description | Navigation |
|-----------|-------------|-------------|------------|
| 01 | LAUNCHING | Màn hình khởi động với logo IGCSE MASTERY | → 02_INTRO-01 |
| 02 | INTRO-01 | Giới thiệu "Online Learning" | → 03_INTRO-02 |
| 03 | INTRO-02 | Giới thiệu "Learn from Anytime" | → 04_INTRO-03 |
| 04 | INTRO-03 | Giới thiệu "Get Online Certificate" | → 05_LET'S YOU IN |

## 🔐 Authentication Flow

| Screen ID | Screen Name | Description | Navigation |
|-----------|-------------|-------------|------------|
| 05 | LET'S YOU IN | Màn hình đăng nhập/đăng ký | → 06_REGISTER NOW, 07_LOGIN |
| 06 | REGISTER NOW | Đăng ký tài khoản mới | → 08_FILL YOUR PROFILE |
| 07 | LOGIN | Đăng nhập | → 08_FILL YOUR PROFILE, 09_FORGOT PASSWORD |
| 08 | FILL YOUR PROFILE | Điền thông tin cá nhân | → 08_CONGRATULATIONS |
| 08 | CONGRATULATIONS | Chúc mừng hoàn thành đăng ký | → 13_HOME |

## 🔑 Password Recovery Flow

| Screen ID | Screen Name | Description | Navigation |
|-----------|-------------|-------------|------------|
| 09 | FORGOT PASSWORD | Quên mật khẩu | → 10_VERIFY-FORGOT PASSWORD |
| 10 | VERIFY-FORGOT PASSWORD | Xác thực mã OTP | → 11_CREATE NEW PASSWORD |
| 11 | CREATE NEW PASSWORD | Tạo mật khẩu mới | → 12_CONGRATULATIONS |
| 12 | CONGRATULATIONS | Chúc mừng đặt lại mật khẩu | → 13_HOME |

## 🏠 HOME Tab

| Screen ID | Screen Name | Description | Navigation |
|-----------|-------------|-------------|------------|
| 13 | HOME | Trang chủ chính | → 14_CATEGORY, 15_SEARCH, 17_POPULAR COURSES, 18_COURSES LIST |
| 14 | CATEGORY | Danh mục khóa học | → 18_COURSES LIST |
| 15 | SEARCH | Tìm kiếm khóa học | → 18_COURSES LIST |
| 17 | POPULAR COURSES | Khóa học phổ biến | → 20_SINGLE COURSE DETAILS |
| 18 | COURSES LIST | Danh sách khóa học | → 20_SINGLE COURSE DETAILS |
| 19 | COURSES LIST-FILTER | Bộ lọc khóa học | → 18_COURSES LIST |

## 📖 Course Details

| Screen ID | Screen Name | Description | Navigation |
|-----------|-------------|-------------|------------|
| 20 | SINGLE COURSE DETAILS | Chi tiết khóa học | → 21_CURRICULCUM, 24_CURRICULCUM, 25_REVIEWS, 26_WRITE REVIEWS, 26_PAYMENT METHODS |
| 21 | SINGLE COURSE DETAILS - CURRICULCUM | Chương trình học chi tiết | → 20_SINGLE COURSE DETAILS |
| 24 | CURRICULCUM | Chương trình học | → 20_SINGLE COURSE DETAILS |
| 25 | REVIEWS | Đánh giá khóa học | → 26_WRITE REVIEWS |
| 26 | WRITE REVIEWS | Viết đánh giá | → 25_REVIEWS |

## 📚 MY COURSES Tab

| Screen ID | Screen Name | Description | Navigation |
|-----------|-------------|-------------|------------|
| 28 | MY COURSE - COMPLETED | Khóa học đã hoàn thành | → 29_LESSONS_COMPLETED, 43_QUIZ SCREEN |
| 29 | MY COURSE - LESSONS - COMPLETED | Bài học đã hoàn thành | → 43_QUIZ SCREEN |
| 30 | MY COURSE - ONGOING | Khóa học đang học | → 31_LESSONS_ONGOING, 43_QUIZ SCREEN |
| 31 | MY COURSE - ONGOING - LESSONS | Bài học đang học | → 32_VIDEO, 43_QUIZ SCREEN |
| 32 | MY COURSE - ONGOING - VIDEO | Video đang học | → 33_COURSE_COMPLETED |
| 33 | MY COURSE - COURSE COMPLETED | Hoàn thành khóa học | → 43_QUIZ SCREEN |

## 🧠 Quiz System

| Screen ID | Screen Name | Description | Navigation |
|-----------|-------------|-------------|------------|
| 43 | QUIZ SCREEN | Màn hình quiz | → 44_QUIZ DETAIL SCREEN |
| 44 | QUIZ DETAIL SCREEN | Chi tiết câu hỏi quiz | → 43_QUIZ SCREEN |

## 💬 LUNABY Tab (AI Assistant)

| Screen ID | Screen Name | Description | Navigation |
|-----------|-------------|-------------|------------|
| 34 | LUNABY UI - YOUR AI ASSISTANT | Trợ lý AI | → 13_HOME |

## 💳 TRANSACTION Tab

| Screen ID | Screen Name | Description | Navigation |
|-----------|-------------|-------------|------------|
| 35 | TRANSACTIONS | Lịch sử giao dịch | → 36_E-RECEIPT |
| 26 | PAYMENT METHODS | Phương thức thanh toán | → 27_PAYMENT SUCCESS |
| 27 | PAYMENT SUCCESS | Thanh toán thành công | → 36_E-RECEIPT |
| 36 | E-RECEIPT | Hóa đơn điện tử | → 37_E-RECEIPT_EDIT |
| 37 | E-RECEIPT - EDIT | Chỉnh sửa hóa đơn | → 36_E-RECEIPT |

## 👤 PROFILE Tab

| Screen ID | Screen Name | Description | Navigation |
|-----------|-------------|-------------|------------|
| 38 | PROFILES | Trang cá nhân | → 39_EDIT_PROFILES, 40_NOTIFICATIONS, 41_PAYMENT_OPTIONS, 22_MY_BOOKMARK |
| 39 | EDIT PROFILES | Chỉnh sửa hồ sơ | → 38_PROFILES |
| 40 | NOTIFICATIONS | Cài đặt thông báo | → 38_PROFILES |
| 41 | PAYMENT OPTIONS | Tùy chọn thanh toán | → 42_ADD_NEW_CARD |
| 42 | ADD NEW CARD | Thêm thẻ mới | → 26_PAYMENT METHODS |
| 22 | MY BOOKMARK | Đánh dấu của tôi | → 20_SINGLE COURSE DETAILS |

## 📱 Bottom Navigation Bar

| Tab | Icon | Screen | Description |
|-----|------|--------|-------------|
| 🏠 | HOME | 13_HOME | Trang chủ chính |
| 📚 | MY COURSES | 28-33, 43-44 | Khóa học của tôi + Quiz |
| 💬 | LUNABY | 34 | AI Assistant |
| 💳 | TRANSACTION | 35, 26-27, 36-37 | Giao dịch + Thanh toán |
| 👤 | PROFILE | 38-42, 22 | Hồ sơ + Đánh dấu |

## 🔄 Navigation Flow Summary

### Main Flow
1. **Onboarding** → **Authentication** → **Home**
2. **Home** → **Course Details** → **Payment** → **Transaction**
3. **Home** → **My Courses** → **Quiz System**
4. **Home** → **Profile** → **Settings/Bookmarks**

### Key Features
- **Course Discovery**: Search, Categories, Popular Courses
- **Learning Management**: My Courses, Lessons, Videos, Quizzes
- **AI Assistant**: LUNABY for learning support
- **Payment System**: Multiple payment methods, receipts
- **Profile Management**: Settings, bookmarks, notifications

## 📊 Screen Statistics
- **Total Screens**: 44
- **Onboarding**: 4 screens
- **Authentication**: 8 screens
- **Main App**: 32 screens
- **Bottom Navigation Tabs**: 5 tabs
