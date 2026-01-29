-- Sample Database Data for Fashion Store
-- This script inserts sample categories and products for testing

-- Clear existing data (optional - comment out if you want to keep existing data)
-- DELETE FROM InvoiceItems;
-- DELETE FROM Invoices;
-- DELETE FROM Products;
-- DELETE FROM Categories;

-- Insert Categories with different tax rates
INSERT INTO Categories (Name, TaxPercent) VALUES
('Áo Thun', 10.00),
('Áo Sơ Mi', 10.00),
('Quần Jean', 10.00),
('Quần Short', 10.00),
('Váy', 10.00),
('Đầm', 10.00),
('Áo Khoác', 10.00),
('Giày Thể Thao', 8.00),
('Giày Cao Gót', 8.00),
('Sandal', 8.00),
('Boots', 8.00),
('Túi Xách', 5.00),
('Ví', 5.00),
('Thắt Lưng', 5.00),
('Mũ', 5.00),
('Kính Mát', 5.00),
('Áo Lót', 0.00),
('Quần Lót', 0.00),
('Tất', 0.00),
('Vòng Tay', 0.00),
('Nhẫn', 0.00),
('Dây Chuyền', 0.00)
ON DUPLICATE KEY UPDATE TaxPercent = VALUES(TaxPercent);

-- Get Category IDs (assuming they are inserted in order)
SET @cat_ao_thun = (SELECT Id FROM Categories WHERE Name = 'Áo Thun' LIMIT 1);
SET @cat_ao_so_mi = (SELECT Id FROM Categories WHERE Name = 'Áo Sơ Mi' LIMIT 1);
SET @cat_quan_jean = (SELECT Id FROM Categories WHERE Name = 'Quần Jean' LIMIT 1);
SET @cat_quan_short = (SELECT Id FROM Categories WHERE Name = 'Quần Short' LIMIT 1);
SET @cat_vay = (SELECT Id FROM Categories WHERE Name = 'Váy' LIMIT 1);
SET @cat_dam = (SELECT Id FROM Categories WHERE Name = 'Đầm' LIMIT 1);
SET @cat_ao_khoac = (SELECT Id FROM Categories WHERE Name = 'Áo Khoác' LIMIT 1);
SET @cat_giay_the_thao = (SELECT Id FROM Categories WHERE Name = 'Giày Thể Thao' LIMIT 1);
SET @cat_giay_cao_got = (SELECT Id FROM Categories WHERE Name = 'Giày Cao Gót' LIMIT 1);
SET @cat_sandal = (SELECT Id FROM Categories WHERE Name = 'Sandal' LIMIT 1);
SET @cat_boots = (SELECT Id FROM Categories WHERE Name = 'Boots' LIMIT 1);
SET @cat_tui_xach = (SELECT Id FROM Categories WHERE Name = 'Túi Xách' LIMIT 1);
SET @cat_vi = (SELECT Id FROM Categories WHERE Name = 'Ví' LIMIT 1);
SET @cat_that_lung = (SELECT Id FROM Categories WHERE Name = 'Thắt Lưng' LIMIT 1);
SET @cat_mu = (SELECT Id FROM Categories WHERE Name = 'Mũ' LIMIT 1);
SET @cat_kinh_mat = (SELECT Id FROM Categories WHERE Name = 'Kính Mát' LIMIT 1);
SET @cat_ao_lot = (SELECT Id FROM Categories WHERE Name = 'Áo Lót' LIMIT 1);
SET @cat_quan_lot = (SELECT Id FROM Categories WHERE Name = 'Quần Lót' LIMIT 1);
SET @cat_tat = (SELECT Id FROM Categories WHERE Name = 'Tất' LIMIT 1);
SET @cat_vong_tay = (SELECT Id FROM Categories WHERE Name = 'Vòng Tay' LIMIT 1);
SET @cat_nhan = (SELECT Id FROM Categories WHERE Name = 'Nhẫn' LIMIT 1);
SET @cat_day_chuyen = (SELECT Id FROM Categories WHERE Name = 'Dây Chuyền' LIMIT 1);

-- Insert Products - Áo Thun
INSERT INTO Products (Name, Code, CategoryId, SalePrice, PurchasePrice, PurchaseUnit, ImportQuantity, StockQuantity, Description) VALUES
('Áo Thun Cổ Tròn Basic', 'AT001', @cat_ao_thun, 150000, 80000, 'Cái', 50, 50, 'Áo thun cổ tròn chất liệu cotton 100%, thoáng mát'),
('Áo Thun Cổ Tròn In Hình', 'AT002', @cat_ao_thun, 180000, 100000, 'Cái', 30, 30, 'Áo thun cổ tròn có in hình độc đáo'),
('Áo Thun Tay Dài', 'AT003', @cat_ao_thun, 200000, 120000, 'Cái', 25, 25, 'Áo thun tay dài mùa đông'),
('Áo Thun Polo', 'AT004', @cat_ao_thun, 250000, 150000, 'Cái', 40, 40, 'Áo polo cổ bẻ, lịch sự'),
('Áo Thun Oversize', 'AT005', @cat_ao_thun, 220000, 130000, 'Cái', 35, 35, 'Áo thun form rộng, trẻ trung')
ON DUPLICATE KEY UPDATE Name = VALUES(Name);

-- Sample promotions (per product)
-- 10% off for 30 days
UPDATE Products
SET PromoDiscountPercent = 10.00,
    PromoStartDate = NOW(),
    PromoEndDate = DATE_ADD(NOW(), INTERVAL 30 DAY)
WHERE Code IN ('AT001','ASM001','QJ001','GTT001','TX001');

-- Flash sale 20% off for 7 days
UPDATE Products
SET PromoDiscountPercent = 20.00,
    PromoStartDate = NOW(),
    PromoEndDate = DATE_ADD(NOW(), INTERVAL 7 DAY)
WHERE Code IN ('D001','AK003','GCG002');

-- Insert Products - Áo Sơ Mi
INSERT INTO Products (Name, Code, CategoryId, SalePrice, PurchasePrice, PurchaseUnit, ImportQuantity, StockQuantity, Description) VALUES
('Áo Sơ Mi Trắng Cổ Điển', 'ASM001', @cat_ao_so_mi, 350000, 200000, 'Cái', 20, 20, 'Áo sơ mi trắng cổ điển, văn phòng'),
('Áo Sơ Mi Kẻ Sọc', 'ASM002', @cat_ao_so_mi, 380000, 220000, 'Cái', 18, 18, 'Áo sơ mi kẻ sọc thanh lịch'),
('Áo Sơ Mi Tay Ngắn', 'ASM003', @cat_ao_so_mi, 320000, 180000, 'Cái', 25, 25, 'Áo sơ mi tay ngắn mùa hè'),
('Áo Sơ Mi Màu Xanh', 'ASM004', @cat_ao_so_mi, 360000, 210000, 'Cái', 22, 22, 'Áo sơ mi màu xanh dương'),
('Áo Sơ Mi Form Rộng', 'ASM005', @cat_ao_so_mi, 400000, 240000, 'Cái', 15, 15, 'Áo sơ mi form rộng, unisex')
ON DUPLICATE KEY UPDATE Name = VALUES(Name);

-- Insert Products - Quần Jean
INSERT INTO Products (Name, Code, CategoryId, SalePrice, PurchasePrice, PurchaseUnit, ImportQuantity, StockQuantity, Description) VALUES
('Quần Jean Xanh Đậm', 'QJ001', @cat_quan_jean, 650000, 400000, 'Cái', 30, 30, 'Quần jean xanh đậm, form slim'),
('Quần Jean Xanh Nhạt', 'QJ002', @cat_quan_jean, 680000, 420000, 'Cái', 28, 28, 'Quần jean xanh nhạt, rách gối'),
('Quần Jean Đen', 'QJ003', @cat_quan_jean, 700000, 430000, 'Cái', 25, 25, 'Quần jean đen, form skinny'),
('Quần Jean Ống Rộng', 'QJ004', @cat_quan_jean, 720000, 450000, 'Cái', 20, 20, 'Quần jean ống rộng, phong cách streetwear'),
('Quần Jean Cạp Cao', 'QJ005', @cat_quan_jean, 750000, 470000, 'Cái', 22, 22, 'Quần jean cạp cao, tôn dáng')
ON DUPLICATE KEY UPDATE Name = VALUES(Name);

-- Insert Products - Quần Short
INSERT INTO Products (Name, Code, CategoryId, SalePrice, PurchasePrice, PurchaseUnit, ImportQuantity, StockQuantity, Description) VALUES
('Quần Short Kaki', 'QS001', @cat_quan_short, 250000, 150000, 'Cái', 40, 40, 'Quần short kaki, mùa hè'),
('Quần Short Thể Thao', 'QS002', @cat_quan_short, 200000, 120000, 'Cái', 50, 50, 'Quần short thể thao, co giãn'),
('Quần Short Denim', 'QS003', @cat_quan_short, 280000, 170000, 'Cái', 35, 35, 'Quần short denim, trẻ trung'),
('Quần Short Cargo', 'QS004', @cat_quan_short, 300000, 180000, 'Cái', 30, 30, 'Quần short cargo, nhiều túi'),
('Quần Short Lưng Thun', 'QS005', @cat_quan_short, 220000, 130000, 'Cái', 45, 45, 'Quần short lưng thun, thoải mái')
ON DUPLICATE KEY UPDATE Name = VALUES(Name);

-- Insert Products - Váy
INSERT INTO Products (Name, Code, CategoryId, SalePrice, PurchasePrice, PurchaseUnit, ImportQuantity, StockQuantity, Description) VALUES
('Váy Chữ A', 'V001', @cat_vay, 450000, 280000, 'Cái', 25, 25, 'Váy chữ A, dài đến gối'),
('Váy Body', 'V002', @cat_vay, 500000, 300000, 'Cái', 20, 20, 'Váy body, ôm sát'),
('Váy Xòe', 'V003', @cat_vay, 550000, 330000, 'Cái', 18, 18, 'Váy xòe, dài đến mắt cá'),
('Váy Ngắn', 'V004', @cat_vay, 400000, 250000, 'Cái', 30, 30, 'Váy ngắn, trẻ trung'),
('Váy Maxi', 'V005', @cat_vay, 600000, 360000, 'Cái', 15, 15, 'Váy maxi, dài đến chân')
ON DUPLICATE KEY UPDATE Name = VALUES(Name);

-- Insert Products - Đầm
INSERT INTO Products (Name, Code, CategoryId, SalePrice, PurchasePrice, PurchaseUnit, ImportQuantity, StockQuantity, Description) VALUES
('Đầm Dự Tiệc', 'D001', @cat_dam, 1200000, 700000, 'Cái', 10, 10, 'Đầm dự tiệc, sang trọng'),
('Đầm Công Sở', 'D002', @cat_dam, 800000, 480000, 'Cái', 15, 15, 'Đầm công sở, thanh lịch'),
('Đầm Mùa Hè', 'D003', @cat_dam, 650000, 390000, 'Cái', 20, 20, 'Đầm mùa hè, thoáng mát'),
('Đầm Tay Dài', 'D004', @cat_dam, 900000, 540000, 'Cái', 12, 12, 'Đầm tay dài, mùa đông'),
('Đầm Hai Dây', 'D005', @cat_dam, 550000, 330000, 'Cái', 25, 25, 'Đầm hai dây, trẻ trung')
ON DUPLICATE KEY UPDATE Name = VALUES(Name);

-- Insert Products - Áo Khoác
INSERT INTO Products (Name, Code, CategoryId, SalePrice, PurchasePrice, PurchaseUnit, ImportQuantity, StockQuantity, Description) VALUES
('Áo Khoác Kaki', 'AK001', @cat_ao_khoac, 850000, 500000, 'Cái', 20, 20, 'Áo khoác kaki, mùa thu'),
('Áo Khoác Dù', 'AK002', @cat_ao_khoac, 450000, 270000, 'Cái', 30, 30, 'Áo khoác dù, chống nước'),
('Áo Khoác Bomber', 'AK003', @cat_ao_khoac, 950000, 570000, 'Cái', 18, 18, 'Áo khoác bomber, phong cách'),
('Áo Khoác Len', 'AK004', @cat_ao_khoac, 1100000, 660000, 'Cái', 15, 15, 'Áo khoác len, mùa đông'),
('Áo Khoác Hoodie', 'AK005', @cat_ao_khoac, 750000, 450000, 'Cái', 25, 25, 'Áo khoác hoodie, thể thao')
ON DUPLICATE KEY UPDATE Name = VALUES(Name);

-- Insert Products - Giày Thể Thao
INSERT INTO Products (Name, Code, CategoryId, SalePrice, PurchasePrice, PurchaseUnit, ImportQuantity, StockQuantity, Description) VALUES
('Giày Thể Thao Chạy Bộ', 'GTT001', @cat_giay_the_thao, 1200000, 720000, 'Đôi', 20, 20, 'Giày thể thao chạy bộ, đế mềm'),
('Giày Thể Thao Đá Bóng', 'GTT002', @cat_giay_the_thao, 1500000, 900000, 'Đôi', 15, 15, 'Giày đá bóng, chuyên dụng'),
('Giày Thể Thao Đi Bộ', 'GTT003', @cat_giay_the_thao, 1000000, 600000, 'Đôi', 25, 25, 'Giày đi bộ, thoải mái'),
('Giày Thể Thao Thời Trang', 'GTT004', @cat_giay_the_thao, 1800000, 1080000, 'Đôi', 12, 12, 'Giày thể thao thời trang, phong cách'),
('Giày Thể Thao Cao Cổ', 'GTT005', @cat_giay_the_thao, 1400000, 840000, 'Đôi', 18, 18, 'Giày thể thao cao cổ, bảo vệ mắt cá')
ON DUPLICATE KEY UPDATE Name = VALUES(Name);

-- Insert Products - Giày Cao Gót
INSERT INTO Products (Name, Code, CategoryId, SalePrice, PurchasePrice, PurchaseUnit, ImportQuantity, StockQuantity, Description) VALUES
('Giày Cao Gót 7cm', 'GCG001', @cat_giay_cao_got, 800000, 480000, 'Đôi', 20, 20, 'Giày cao gót 7cm, cổ điển'),
('Giày Cao Gót 10cm', 'GCG002', @cat_giay_cao_got, 950000, 570000, 'Đôi', 15, 15, 'Giày cao gót 10cm, sang trọng'),
('Giày Cao Gót Mũi Nhọn', 'GCG003', @cat_giay_cao_got, 1100000, 660000, 'Đôi', 12, 12, 'Giày cao gót mũi nhọn, thanh lịch'),
('Giày Cao Gót Mũi Tròn', 'GCG004', @cat_giay_cao_got, 750000, 450000, 'Đôi', 25, 25, 'Giày cao gót mũi tròn, thoải mái'),
('Giày Cao Gót Đế Thấp', 'GCG005', @cat_giay_cao_got, 650000, 390000, 'Đôi', 30, 30, 'Giày cao gót đế thấp, dễ đi')
ON DUPLICATE KEY UPDATE Name = VALUES(Name);

-- Insert Products - Sandal
INSERT INTO Products (Name, Code, CategoryId, SalePrice, PurchasePrice, PurchaseUnit, ImportQuantity, StockQuantity, Description) VALUES
('Sandal Quai Ngang', 'SD001', @cat_sandal, 350000, 210000, 'Đôi', 40, 40, 'Sandal quai ngang, mùa hè'),
('Sandal Quai Chéo', 'SD002', @cat_sandal, 400000, 240000, 'Đôi', 35, 35, 'Sandal quai chéo, thời trang'),
('Sandal Đế Bệt', 'SD003', @cat_sandal, 300000, 180000, 'Đôi', 45, 45, 'Sandal đế bệt, thoải mái'),
('Sandal Có Gót', 'SD004', @cat_sandal, 450000, 270000, 'Đôi', 30, 30, 'Sandal có gót nhỏ, tôn dáng'),
('Sandal Thể Thao', 'SD005', @cat_sandal, 500000, 300000, 'Đôi', 25, 25, 'Sandal thể thao, đi biển')
ON DUPLICATE KEY UPDATE Name = VALUES(Name);

-- Insert Products - Boots
INSERT INTO Products (Name, Code, CategoryId, SalePrice, PurchasePrice, PurchaseUnit, ImportQuantity, StockQuantity, Description) VALUES
('Boots Cổ Cao', 'BT001', @cat_boots, 1500000, 900000, 'Đôi', 15, 15, 'Boots cổ cao, mùa đông'),
('Boots Cổ Thấp', 'BT002', @cat_boots, 1200000, 720000, 'Đôi', 20, 20, 'Boots cổ thấp, linh hoạt'),
('Boots Da', 'BT003', @cat_boots, 1800000, 1080000, 'Đôi', 12, 12, 'Boots da thật, cao cấp'),
('Boots Thể Thao', 'BT004', @cat_boots, 1300000, 780000, 'Đôi', 18, 18, 'Boots thể thao, năng động'),
('Boots Mũi Nhọn', 'BT005', @cat_boots, 1600000, 960000, 'Đôi', 10, 10, 'Boots mũi nhọn, thời trang')
ON DUPLICATE KEY UPDATE Name = VALUES(Name);

-- Insert Products - Túi Xách
INSERT INTO Products (Name, Code, CategoryId, SalePrice, PurchasePrice, PurchaseUnit, ImportQuantity, StockQuantity, Description) VALUES
('Túi Xách Tay', 'TX001', @cat_tui_xach, 800000, 480000, 'Cái', 20, 20, 'Túi xách tay, công sở'),
('Túi Xách Đeo Vai', 'TX002', @cat_tui_xach, 650000, 390000, 'Cái', 25, 25, 'Túi xách đeo vai, tiện lợi'),
('Túi Xách Da', 'TX003', @cat_tui_xach, 1200000, 720000, 'Cái', 15, 15, 'Túi xách da thật, sang trọng'),
('Túi Xách Tote', 'TX004', @cat_tui_xach, 550000, 330000, 'Cái', 30, 30, 'Túi tote, rộng rãi'),
('Túi Xách Mini', 'TX005', @cat_tui_xach, 450000, 270000, 'Cái', 35, 35, 'Túi xách mini, xinh xắn')
ON DUPLICATE KEY UPDATE Name = VALUES(Name);

-- Insert Products - Ví
INSERT INTO Products (Name, Code, CategoryId, SalePrice, PurchasePrice, PurchaseUnit, ImportQuantity, StockQuantity, Description) VALUES
('Ví Da Nam', 'V001', @cat_vi, 350000, 210000, 'Cái', 40, 40, 'Ví da nam, nhiều ngăn'),
('Ví Da Nữ', 'V002', @cat_vi, 400000, 240000, 'Cái', 35, 35, 'Ví da nữ, xinh xắn'),
('Ví Dài', 'V003', @cat_vi, 300000, 180000, 'Cái', 45, 45, 'Ví dài, đựng tiền'),
('Ví Ngắn', 'V004', @cat_vi, 280000, 168000, 'Cái', 50, 50, 'Ví ngắn, gọn nhẹ'),
('Ví Có Khóa', 'V005', @cat_vi, 450000, 270000, 'Cái', 30, 30, 'Ví có khóa, an toàn')
ON DUPLICATE KEY UPDATE Name = VALUES(Name);

-- Insert Products - Thắt Lưng
INSERT INTO Products (Name, Code, CategoryId, SalePrice, PurchasePrice, PurchaseUnit, ImportQuantity, StockQuantity, Description) VALUES
('Thắt Lưng Da Nam', 'TL001', @cat_that_lung, 250000, 150000, 'Cái', 50, 50, 'Thắt lưng da nam, cổ điển'),
('Thắt Lưng Da Nữ', 'TL002', @cat_that_lung, 200000, 120000, 'Cái', 45, 45, 'Thắt lưng da nữ, thanh lịch'),
('Thắt Lưng Vải', 'TL003', @cat_that_lung, 150000, 90000, 'Cái', 60, 60, 'Thắt lưng vải, thể thao'),
('Thắt Lưng Kim Loại', 'TL004', @cat_that_lung, 300000, 180000, 'Cái', 35, 35, 'Thắt lưng kim loại, thời trang'),
('Thắt Lưng Rộng', 'TL005', @cat_that_lung, 220000, 132000, 'Cái', 40, 40, 'Thắt lưng rộng, phong cách')
ON DUPLICATE KEY UPDATE Name = VALUES(Name);

-- Insert Products - Mũ
INSERT INTO Products (Name, Code, CategoryId, SalePrice, PurchasePrice, PurchaseUnit, ImportQuantity, StockQuantity, Description) VALUES
('Mũ Lưỡi Trai', 'M001', @cat_mu, 180000, 108000, 'Cái', 50, 50, 'Mũ lưỡi trai, thể thao'),
('Mũ Bucket', 'M002', @cat_mu, 200000, 120000, 'Cái', 40, 40, 'Mũ bucket, thời trang'),
('Mũ Phớt', 'M003', @cat_mu, 250000, 150000, 'Cái', 30, 30, 'Mũ phớt, cổ điển'),
('Mũ Snapback', 'M004', @cat_mu, 220000, 132000, 'Cái', 35, 35, 'Mũ snapback, trẻ trung'),
('Mũ Rộng Vành', 'M005', @cat_mu, 300000, 180000, 'Cái', 25, 25, 'Mũ rộng vành, chống nắng')
ON DUPLICATE KEY UPDATE Name = VALUES(Name);

-- Insert Products - Kính Mát
INSERT INTO Products (Name, Code, CategoryId, SalePrice, PurchasePrice, PurchaseUnit, ImportQuantity, StockQuantity, Description) VALUES
('Kính Mát Aviator', 'KM001', @cat_kinh_mat, 500000, 300000, 'Cái', 30, 30, 'Kính mát aviator, cổ điển'),
('Kính Mát Wayfarer', 'KM002', @cat_kinh_mat, 450000, 270000, 'Cái', 35, 35, 'Kính mát wayfarer, thời trang'),
('Kính Mát Tròn', 'KM003', @cat_kinh_mat, 400000, 240000, 'Cái', 40, 40, 'Kính mát tròn, phong cách'),
('Kính Mát Thể Thao', 'KM004', @cat_kinh_mat, 600000, 360000, 'Cái', 25, 25, 'Kính mát thể thao, chống UV'),
('Kính Mát Trẻ Em', 'KM005', @cat_kinh_mat, 300000, 180000, 'Cái', 45, 45, 'Kính mát trẻ em, an toàn')
ON DUPLICATE KEY UPDATE Name = VALUES(Name);

-- Insert Products - Áo Lót
INSERT INTO Products (Name, Code, CategoryId, SalePrice, PurchasePrice, PurchaseUnit, ImportQuantity, StockQuantity, Description) VALUES
('Áo Lót Có Gọng', 'AL001', @cat_ao_lot, 250000, 150000, 'Cái', 60, 60, 'Áo lót có gọng, nâng đỡ'),
('Áo Lót Không Gọng', 'AL002', @cat_ao_lot, 200000, 120000, 'Cái', 70, 70, 'Áo lót không gọng, thoải mái'),
('Áo Lót Thể Thao', 'AL003', @cat_ao_lot, 300000, 180000, 'Cái', 50, 50, 'Áo lót thể thao, co giãn'),
('Áo Lót Push-up', 'AL004', @cat_ao_lot, 350000, 210000, 'Cái', 40, 40, 'Áo lót push-up, tôn dáng'),
('Áo Lót Không Dây', 'AL005', @cat_ao_lot, 280000, 168000, 'Cái', 55, 55, 'Áo lót không dây, tiện lợi')
ON DUPLICATE KEY UPDATE Name = VALUES(Name);

-- Insert Products - Quần Lót
INSERT INTO Products (Name, Code, CategoryId, SalePrice, PurchasePrice, PurchaseUnit, ImportQuantity, StockQuantity, Description) VALUES
('Quần Lót Cotton', 'QL001', @cat_quan_lot, 80000, 48000, 'Cái', 100, 100, 'Quần lót cotton, thoáng mát'),
('Quần Lót Lace', 'QL002', @cat_quan_lot, 120000, 72000, 'Cái', 80, 80, 'Quần lót lace, quyến rũ'),
('Quần Lót Thể Thao', 'QL003', @cat_quan_lot, 150000, 90000, 'Cái', 70, 70, 'Quần lót thể thao, khô ráo'),
('Quần Lót Seamless', 'QL004', @cat_quan_lot, 100000, 60000, 'Cái', 90, 90, 'Quần lót seamless, không đường may'),
('Quần Lót Boxer', 'QL005', @cat_quan_lot, 110000, 66000, 'Cái', 85, 85, 'Quần lót boxer, rộng rãi')
ON DUPLICATE KEY UPDATE Name = VALUES(Name);

-- Insert Products - Tất
INSERT INTO Products (Name, Code, CategoryId, SalePrice, PurchasePrice, PurchaseUnit, ImportQuantity, StockQuantity, Description) VALUES
('Tất Ngắn', 'T001', @cat_tat, 30000, 18000, 'Đôi', 200, 200, 'Tất ngắn, thể thao'),
('Tất Dài', 'T002', @cat_tat, 40000, 24000, 'Đôi', 150, 150, 'Tất dài, mùa đông'),
('Tất Cổ Ngắn', 'T003', @cat_tat, 25000, 15000, 'Đôi', 250, 250, 'Tất cổ ngắn, mùa hè'),
('Tất Có Họa Tiết', 'T004', @cat_tat, 50000, 30000, 'Đôi', 120, 120, 'Tất có họa tiết, thời trang'),
('Tất Vớ', 'T005', @cat_tat, 35000, 21000, 'Đôi', 180, 180, 'Tất vớ, ấm áp')
ON DUPLICATE KEY UPDATE Name = VALUES(Name);

-- Insert Products - Vòng Tay
INSERT INTO Products (Name, Code, CategoryId, SalePrice, PurchasePrice, PurchaseUnit, ImportQuantity, StockQuantity, Description) VALUES
('Vòng Tay Bạc', 'VT001', @cat_vong_tay, 500000, 300000, 'Cái', 30, 30, 'Vòng tay bạc, tinh xảo'),
('Vòng Tay Vàng', 'VT002', @cat_vong_tay, 2000000, 1200000, 'Cái', 10, 10, 'Vòng tay vàng, cao cấp'),
('Vòng Tay Đồng', 'VT003', @cat_vong_tay, 300000, 180000, 'Cái', 40, 40, 'Vòng tay đồng, phong cách'),
('Vòng Tay Da', 'VT004', @cat_vong_tay, 250000, 150000, 'Cái', 50, 50, 'Vòng tay da, nam tính'),
('Vòng Tay Charm', 'VT005', @cat_vong_tay, 400000, 240000, 'Cái', 25, 25, 'Vòng tay charm, cá tính')
ON DUPLICATE KEY UPDATE Name = VALUES(Name);

-- Insert Products - Nhẫn
INSERT INTO Products (Name, Code, CategoryId, SalePrice, PurchasePrice, PurchaseUnit, ImportQuantity, StockQuantity, Description) VALUES
('Nhẫn Cưới Vàng', 'N001', @cat_nhan, 5000000, 3000000, 'Cái', 5, 5, 'Nhẫn cưới vàng, cao cấp'),
('Nhẫn Bạc', 'N002', @cat_nhan, 600000, 360000, 'Cái', 20, 20, 'Nhẫn bạc, tinh xảo'),
('Nhẫn Đồng', 'N003', @cat_nhan, 350000, 210000, 'Cái', 35, 35, 'Nhẫn đồng, phong cách'),
('Nhẫn Có Đá', 'N004', @cat_nhan, 1200000, 720000, 'Cái', 15, 15, 'Nhẫn có đá, sang trọng'),
('Nhẫn Trơn', 'N005', @cat_nhan, 400000, 240000, 'Cái', 30, 30, 'Nhẫn trơn, đơn giản')
ON DUPLICATE KEY UPDATE Name = VALUES(Name);

-- Insert Products - Dây Chuyền
INSERT INTO Products (Name, Code, CategoryId, SalePrice, PurchasePrice, PurchaseUnit, ImportQuantity, StockQuantity, Description) VALUES
('Dây Chuyền Bạc', 'DC001', @cat_day_chuyen, 800000, 480000, 'Cái', 25, 25, 'Dây chuyền bạc, thanh lịch'),
('Dây Chuyền Vàng', 'DC002', @cat_day_chuyen, 3000000, 1800000, 'Cái', 8, 8, 'Dây chuyền vàng, cao cấp'),
('Dây Chuyền Có Mặt Dây', 'DC003', @cat_day_chuyen, 1200000, 720000, 'Cái', 15, 15, 'Dây chuyền có mặt dây, sang trọng'),
('Dây Chuyền Đồng', 'DC004', @cat_day_chuyen, 500000, 300000, 'Cái', 30, 30, 'Dây chuyền đồng, phong cách'),
('Dây Chuyền Ngắn', 'DC005', @cat_day_chuyen, 600000, 360000, 'Cái', 20, 20, 'Dây chuyền ngắn, cổ điển')
ON DUPLICATE KEY UPDATE Name = VALUES(Name);

-- Summary
SELECT 'Sample data inserted successfully!' AS Message;
SELECT COUNT(*) AS TotalCategories FROM Categories;
SELECT COUNT(*) AS TotalProducts FROM Products;

