# KIẾN TRÚC CHƯƠNG TRÌNH - HỆ THỐNG QUẢN LÝ BÁN HÀNG

## 1. TỔNG QUAN KIẾN TRÚC

Hệ thống được xây dựng theo mô hình **Layered Architecture (Kiến trúc phân lớp)** với 3 lớp chính:

```
┌─────────────────────────────────────────┐
│  PRESENTATION LAYER                     │
│  - Giao diện người dùng (UI)            │
│  - Xử lý tương tác người dùng           │
│  - Hiển thị dữ liệu                     │
└─────────────────────────────────────────┘
                  ↕
┌─────────────────────────────────────────┐
│  BUSINESS LOGIC LAYER                   │
│  - Logic nghiệp vụ                      │
│  - Xử lý nghiệp vụ (tính toán, validate)│
│  - Quản lý cấu hình                     │
│  - Các thành phần hỗ trợ                │
└─────────────────────────────────────────┘
                  ↕
┌─────────────────────────────────────────┐
│  DATA ACCESS LAYER                      │
│  - Truy cập dữ liệu                     │
│  - Kết nối cơ sở dữ liệu                │
│  - Quản lý giao dịch                    │
└─────────────────────────────────────────┘
                  ↕
┌─────────────────────────────────────────┐
│  EXTERNAL SYSTEMS                       │
│  - MySQL Database                       │
│  - VietQR API (Payment Gateway)        │
└─────────────────────────────────────────┘
```

### 1.1. Mô tả các lớp

- **Presentation Layer**: Chịu trách nhiệm hiển thị giao diện người dùng và xử lý các tương tác. Không chứa logic nghiệp vụ phức tạp, chỉ chuyển tiếp yêu cầu xuống Business Logic Layer.

- **Business Logic Layer**: Chứa toàn bộ logic nghiệp vụ như tính toán giá, kiểm tra tồn kho, tính điểm tích lũy, quản lý cấu hình hệ thống. Đây là trái tim của hệ thống.

- **Data Access Layer**: Chịu trách nhiệm duy nhất là truy cập dữ liệu, che giấu chi tiết kỹ thuật của database khỏi Business Logic Layer.

- **External Systems**: Các hệ thống bên ngoài mà ứng dụng tích hợp, bao gồm database MySQL và API thanh toán.

### 1.2. Lợi ích của kiến trúc này

- **Tách biệt trách nhiệm**: Mỗi lớp có vai trò rõ ràng, dễ bảo trì
- **Dễ mở rộng**: Có thể thay đổi một lớp mà không ảnh hưởng đến lớp khác
- **Tái sử dụng**: Logic nghiệp vụ có thể được sử dụng ở nhiều nơi
- **Dễ kiểm thử**: Có thể test từng lớp độc lập


## 2. CÁC TÁC NHÂN HỆ THỐNG

### 2.1. Tác nhân trong phần mềm (Internal Actors)

Hệ thống có 3 vai trò người dùng được quản lý qua bảng tài khoản:

- **Admin (Quản trị viên)**: Toàn quyền - quản lý người dùng, sản phẩm, khách hàng, hóa đơn, báo cáo, cấu hình hệ thống
- **Manager (Quản lý)**: Quản lý sản phẩm, khách hàng, hóa đơn, báo cáo, cấu hình (KHÔNG quản lý người dùng)
- **Cashier (Thu ngân)**: Chỉ tạo hóa đơn, quản lý sản phẩm/khách hàng cơ bản (KHÔNG xem báo cáo, KHÔNG cài đặt)

Phân quyền được áp dụng tự động để ẩn/hiện menu theo vai trò người dùng.

### 2.2. Tác nhân ngoài (External Actors)

- **MySQL Database**: 
  - Lưu trữ dữ liệu persistent của hệ thống
  - Các bảng chính: tài khoản người dùng, danh mục sản phẩm, sản phẩm, khách hàng, hóa đơn, chi tiết hóa đơn
  - Hỗ trợ quan hệ giữa các bảng (foreign keys)
  - Tương tác qua lớp truy cập dữ liệu tập trung

- **VietQR API**: 
  - Dịch vụ tạo QR code thanh toán ngân hàng
  - Khi khách chọn phương thức "Chuyển khoản", hệ thống tự động gọi API để tạo QR code
  - QR code chứa thông tin: mã ngân hàng, số tài khoản, tên chủ tài khoản, số tiền, mô tả giao dịch
  - Có cơ chế xử lý lỗi và tạo QR dự phòng khi API không khả dụng

- **File System**: 
  - Lưu trữ cấu hình ứng dụng tại thư mục Application Data
  - Các file cấu hình: database connection, thông tin thanh toán, cài đặt hạng khách hàng
  - Dữ liệu cấu hình được lưu dạng JSON, dễ đọc và chỉnh sửa

## 3. TƯƠNG TÁC GIỮA CÁC THÀNH PHẦN

### 3.1. Luồng xác thực và đăng nhập

**Các bước thực hiện:**
1. Người dùng nhập thông tin đăng nhập (username, password)
2. Hệ thống kiểm tra tính hợp lệ của dữ liệu đầu vào
3. Mã hóa mật khẩu và truy vấn database để xác thực
4. Database trả về vai trò (role) của người dùng nếu đăng nhập thành công
5. Hệ thống tạo phiên làm việc và lưu thông tin người dùng
6. Hiển thị trang chủ (Dashboard) với menu và chức năng được điều chỉnh theo vai trò
7. Áp dụng phân quyền tự động: ẩn/hiện các menu và nút chức năng

**Kết quả:** Người dùng được chuyển đến giao diện chính với quyền truy cập phù hợp với vai trò của mình.

### 3.2. Luồng tạo hóa đơn và thanh toán

**Bước 1: Tạo hóa đơn**
- Người dùng chọn khách hàng từ danh sách
- Thêm sản phẩm vào hóa đơn với số lượng
- Hệ thống tự động kiểm tra tồn kho trước khi cho phép thêm
- Tính toán tự động:
  - Tổng phụ = tổng giá trị các sản phẩm
  - Thuế = tổng phụ × phần trăm thuế
  - Giảm giá thủ công (nếu có)
  - Giảm giá theo hạng khách hàng (tự động áp dụng)
  - Tổng cộng = tổng phụ + thuế - giảm giá
  - Tiền thừa = số tiền đã trả - tổng cộng

**Bước 2: Xử lý thanh toán**
- **Thanh toán tiền mặt:**
  - Người dùng nhập số tiền khách đã trả
  - Hệ thống tính tiền thừa
  - Ẩn QR code thanh toán
  
- **Thanh toán chuyển khoản:**
  - Tải cấu hình thông tin ngân hàng từ file
  - Gọi API VietQR để tạo QR code với thông tin thanh toán
  - Hiển thị QR code trên giao diện để khách quét thanh toán
  - Tính số tiền còn thiếu (nếu khách trả một phần)

**Bước 3: Lưu hóa đơn**
- Kiểm tra tính hợp lệ: phải có ít nhất 1 sản phẩm, phải chọn khách hàng
- Bắt đầu giao dịch database (transaction):
  - Lưu thông tin hóa đơn
  - Lưu chi tiết từng sản phẩm trong hóa đơn
  - Giảm số lượng tồn kho của các sản phẩm đã bán
  - Cập nhật điểm tích lũy và hạng của khách hàng
  - Xác nhận giao dịch (commit) hoặc hủy bỏ (rollback) nếu có lỗi
- Hiển thị thông báo thành công với mã hóa đơn
- Mở cửa sổ in hóa đơn
- Tự động cập nhật dashboard (KPIs, biểu đồ)

### 3.3. Luồng quản lý sản phẩm

**Các thao tác chính:**
- **Xem danh sách**: Hiển thị sản phẩm với phân trang, tìm kiếm theo tên/mã
- **Thêm sản phẩm**: Nhập thông tin (tên, mã, giá bán, giá nhập, danh mục, tồn kho, mô tả)
  - Kiểm tra mã sản phẩm phải duy nhất
  - Validate giá bán > 0
- **Sửa sản phẩm**: Cập nhật thông tin sản phẩm
- **Xóa sản phẩm**: Kiểm tra ràng buộc trước khi xóa
- **Quản lý tồn kho**: Cập nhật số lượng tồn kho khi nhập hàng

**Quy trình:**
Giao diện → Xác thực dữ liệu → Truy cập dữ liệu → Thực hiện thao tác → Làm mới danh sách → Hiển thị kết quả

### 3.4. Luồng báo cáo và thống kê

**Trang chủ (Dashboard):**
- Tải các chỉ số KPI theo thời gian thực:
  - Doanh thu hôm nay
  - Doanh thu 30 ngày gần nhất
  - Số hóa đơn hôm nay
  - Tổng số khách hàng / sản phẩm
- Tạo các biểu đồ:
  - Biểu đồ đường: Doanh thu theo ngày (30 ngày)
  - Biểu đồ tròn: Doanh thu theo danh mục
  - Biểu đồ cột: Top 10 khách hàng chi tiêu cao nhất
  - Biểu đồ cột: Top 10 sản phẩm bán chạy nhất
- Cảnh báo sản phẩm sắp hết (tồn kho ≤ 10)

**Màn hình báo cáo:**
- Bộ lọc theo khoảng thời gian
- Truy vấn tổng hợp dữ liệu từ database
- Tạo biểu đồ và bảng thống kê
- Hiển thị các chỉ số phân tích chi tiết

**Quy trình:** Giao diện → Chọn khoảng thời gian → Truy vấn database → Tính toán tổng hợp → Tạo biểu đồ → Hiển thị kết quả

### 3.5. Luồng quản lý loyalty (Điểm tích lũy)

**Quy trình tự động khi lưu hóa đơn thành công:**
1. Tính điểm tích lũy: 1 điểm cho mỗi 100,000 VNĐ (làm tròn xuống)
   - Ví dụ: Hóa đơn 350,000 VNĐ = 3 điểm
2. Cộng dồn điểm mới vào điểm hiện tại của khách hàng
3. Xác định hạng khách hàng dựa trên tổng điểm:
   - Regular (Mặc định): < ngưỡng điểm
   - Bronze: đạt ngưỡng điểm Bronze
   - Silver: đạt ngưỡng điểm Silver
   - Gold: đạt ngưỡng điểm Gold
   - Platinum: đạt ngưỡng điểm cao nhất
4. Cập nhật điểm và hạng vào database
5. Áp dụng giảm giá theo hạng cho lần mua tiếp theo (tự động trong quá trình tạo hóa đơn mới)

**Tác động:** Khách hàng được hưởng lợi ngay lập tức từ việc tích lũy điểm, tạo động lực mua hàng lặp lại.

## 4. XÂY DỰNG CHỨC NĂNG

### 4.1. Nguyên tắc thiết kế
- **Separation of Concerns**: Tách biệt giao diện người dùng, logic nghiệp vụ, và truy cập dữ liệu
- **Single Responsibility**: Mỗi thành phần có một trách nhiệm duy nhất
- **DRY**: Tái sử dụng code qua các thành phần hỗ trợ
- **Error Handling**: Xử lý lỗi ở các tầng, tránh crash ứng dụng

### 4.2. Cấu trúc các màn hình chính

- **Màn hình đăng nhập**: 
  - Xác thực người dùng với username và password
  - Hỗ trợ đăng nhập bằng phím Enter
  - Cho phép đổi mật khẩu
  - Sau khi đăng nhập thành công, chuyển đến trang chủ với phân quyền tương ứng

- **Trang chủ (Dashboard)**: 
  - Hiển thị các chỉ số KPI quan trọng (doanh thu, số hóa đơn, số khách hàng/sản phẩm)
  - Hiển thị biểu đồ trực quan (doanh thu theo ngày, theo danh mục, top khách hàng/sản phẩm)
  - Cảnh báo sản phẩm sắp hết
  - Menu điều hướng với phân quyền (ẩn/hiện theo vai trò)
  - Tự động cập nhật khi có thay đổi từ các màn hình khác

- **Quản lý hóa đơn**: 
  - Tạo hóa đơn mới với giao diện trực quan
  - Quản lý danh sách sản phẩm trong hóa đơn (thêm, sửa số lượng, xóa)
  - Kiểm tra tồn kho trước khi thêm sản phẩm
  - Tính toán tự động: tổng phụ, thuế, giảm giá, tổng cộng, tiền thừa
  - Tạo và hiển thị QR code thanh toán
  - Lưu hóa đơn với giao dịch đảm bảo tính nhất quán
  - In hóa đơn sau khi lưu

- **Quản lý sản phẩm**: 
  - Xem danh sách sản phẩm với phân trang
  - Thêm/sửa/xóa sản phẩm
  - Quản lý thông tin: tên, mã, giá, danh mục, tồn kho, mô tả
  - Kiểm tra mã sản phẩm trùng lặp
  - Quản lý tồn kho (cập nhật khi nhập hàng)

- **Quản lý danh mục**: 
  - CRUD danh mục sản phẩm
  - Liên kết sản phẩm với danh mục

- **Quản lý khách hàng**: 
  - CRUD khách hàng (thông tin cá nhân, liên hệ)
  - Xem điểm tích lũy và hạng khách hàng
  - Tìm kiếm khách hàng

- **Lịch sử giao dịch**: 
  - Xem danh sách tất cả hóa đơn
  - Tìm kiếm và lọc hóa đơn
  - Xem chi tiết hóa đơn

- **Báo cáo**: 
  - Báo cáo với bộ lọc theo khoảng thời gian
  - Thống kê doanh thu, số lượng bán ra
  - Biểu đồ và bảng phân tích

- **Cài đặt**: 
  - Cấu hình kết nối database
  - Cấu hình thông tin thanh toán (ngân hàng, QR code)
  - Cấu hình hạng khách hàng và phần trăm giảm giá
  - Quản lý người dùng (chỉ Admin)

### 4.3. Các thành phần hỗ trợ quan trọng

- **Lớp truy cập dữ liệu**: 
  - Xử lý tất cả thao tác với database (CRUD)
  - Khởi tạo và tạo bảng database nếu chưa tồn tại
  - Quản lý kết nối database (connection pooling)
  - Thực hiện các truy vấn tổng hợp (aggregation)
  - Quản lý giao dịch (transaction) để đảm bảo tính nhất quán
  - Sử dụng prepared statements để tránh SQL injection

- **Thành phần tạo QR code**: 
  - Tạo QR code thanh toán qua API VietQR
  - Xử lý thông tin ngân hàng và số tiền
  - Có cơ chế xử lý lỗi và timeout
  - Tạo QR code dự phòng khi API không khả dụng
  - Hiển thị thông báo lỗi rõ ràng khi không thể tạo QR code

- **Quản lý cấu hình**: 
  - Lưu và tải cấu hình từ file JSON
  - Quản lý cấu hình database (server, database name, credentials)
  - Quản lý cấu hình thanh toán (thông tin ngân hàng, bật/tắt QR code)
  - Quản lý cấu hình hạng khách hàng (ngưỡng điểm, phần trăm giảm giá)
  - Kiểm tra tính hợp lệ của cấu hình

- **Hỗ trợ phân trang**: 
  - Giảm tải dữ liệu khi hiển thị danh sách lớn
  - Cải thiện hiệu suất và trải nghiệm người dùng

- **Xử lý mật khẩu**: 
  - Mã hóa mật khẩu trước khi lưu vào database
  - Xác thực mật khẩu khi đăng nhập

### 4.4. Tương tác giữa các màn hình

- **Cập nhật theo sự kiện**: 
  - Trang chủ sử dụng cơ chế event-driven để tự động làm mới
  - Khi có thay đổi dữ liệu từ màn hình khác (ví dụ: lưu hóa đơn mới), trang chủ tự động cập nhật KPIs và biểu đồ
  - Không cần reload thủ công, cải thiện trải nghiệm người dùng

- **Chia sẻ dữ liệu**: 
  - Lưu thông tin người dùng hiện tại trong phiên làm việc
  - Các màn hình khác có thể truy cập thông tin này để xác định người thực hiện thao tác (ví dụ: lưu hóa đơn cần biết nhân viên nào tạo)

- **Cửa sổ modal**: 
  - Sử dụng dialog để hiển thị các cửa sổ con
  - Đảm bảo người dùng hoàn tất tác vụ trước khi quay lại màn hình chính
  - Ngăn chặn thao tác đồng thời trên nhiều cửa sổ

- **Điều hướng**: 
  - Menu điều hướng tập trung ở trang chủ
  - Dễ dàng chuyển đổi giữa các chức năng
  - Trở về trang chủ bất cứ lúc nào

### 4.5. Security và Validation

- **Xác thực và phân quyền**: 
  - Mật khẩu được mã hóa trước khi lưu vào database
  - Xác thực người dùng khi đăng nhập
  - Phân quyền theo vai trò (RBAC - Role-Based Access Control)
  - Mỗi vai trò có quyền truy cập khác nhau vào các chức năng
  - Quản lý phiên làm việc, lưu thông tin người dùng đăng nhập

- **Kiểm tra dữ liệu đầu vào**: 
  - Kiểm tra tính hợp lệ của dữ liệu ở nhiều tầng
  - **Sản phẩm**: Mã sản phẩm phải duy nhất, giá > 0, tồn kho ≥ 0
  - **Hóa đơn**: Phải có ít nhất 1 sản phẩm, phải chọn khách hàng
  - **Số lượng**: Phải > 0, không vượt quá tồn kho hiện có
  - **Thanh toán**: Số tiền đã trả ≥ 0, kiểm tra đủ tiền

- **An toàn database**: 
  - Sử dụng prepared statements để tránh SQL injection
  - Tham số hóa các giá trị đầu vào trong câu truy vấn
  - Xác thực quyền truy cập database

- **Giao dịch (Transaction)**: 
  - Đảm bảo tính nhất quán dữ liệu khi lưu hóa đơn
  - Tất cả các thao tác phải thành công hoặc tất cả đều bị hủy bỏ (rollback)
  - Các thao tác trong một transaction:
    - Lưu hóa đơn
    - Lưu chi tiết hóa đơn
    - Cập nhật tồn kho sản phẩm
    - Cập nhật điểm tích lũy khách hàng

### 4.6. Performance và Tối ưu hóa

- **Tối ưu database**: 
  - Sử dụng connection pooling để tái sử dụng kết nối
  - Prepared statements giúp tăng tốc độ truy vấn
  - Phân trang để giảm lượng dữ liệu cần load
  - Index các trường quan trọng để tăng tốc độ tìm kiếm

- **Tối ưu giao diện**: 
  - Lazy loading: chỉ load màn hình khi người dùng mở
  - Cập nhật theo sự kiện thay vì polling định kỳ
  - Render biểu đồ một cách hiệu quả

- **Tối ưu API calls**: 
  - Timeout cho các request API
  - Cơ chế fallback khi API không khả dụng
  - Xử lý bất đồng bộ để không block UI

- **Cache**: 
  - Cache cấu hình trong bộ nhớ để tránh đọc file nhiều lần
  - Xây dựng connection string một lần và tái sử dụng

## 5. CẤU TRÚC DỮ LIỆU

### 5.1. Các bảng chính trong database

- **Bảng tài khoản**: Lưu thông tin người dùng (username, password đã mã hóa, vai trò)
- **Bảng danh mục**: Quản lý các danh mục sản phẩm
- **Bảng sản phẩm**: Thông tin sản phẩm (tên, mã, giá bán, giá nhập, danh mục, tồn kho, mô tả)
- **Bảng khách hàng**: Thông tin khách hàng (tên, số điện thoại, email, địa chỉ, điểm tích lũy, hạng)
- **Bảng hóa đơn**: Thông tin hóa đơn (khách hàng, nhân viên, tổng tiền, thuế, giảm giá, ngày tạo)
- **Bảng chi tiết hóa đơn**: Chi tiết từng sản phẩm trong hóa đơn (sản phẩm, số lượng, đơn giá, thành tiền)

### 5.2. Quan hệ giữa các bảng

- Sản phẩm thuộc về một danh mục
- Hóa đơn thuộc về một khách hàng và một nhân viên
- Chi tiết hóa đơn thuộc về một hóa đơn và một sản phẩm
- Các quan hệ được đảm bảo bằng foreign keys


