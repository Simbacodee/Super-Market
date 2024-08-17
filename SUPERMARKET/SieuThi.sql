use master
drop database SieuThi
create database SieuThi
go
use SieuThi
go
-- 1: Tạo Table [Accounts] chứa tài khoản thành viên được phép sử dụng các trang quản trị ----
create table TaiKhoan
(
	taiKhoan varchar(20) primary key not null,
	matKhau varchar(100) not null,
	hoDem nvarchar(50) null,
	tenTV nvarchar(30) not null,
	ngaysinh datetime ,
	gioiTinh bit default 1,
	soDT nvarchar(20),
	email nvarchar(50),
	diaChi nvarchar(250),
	trangThai bit default 0,
	ghiChu ntext
)
go

-- 2: Tạo Table [Customers] chứa Thông tin khách hàng  ---------------------------------------
create table KhachHang
(
	maKH varchar(10) primary key not null,
	tenKH nvarchar(50) not null,
	soDT varchar(20) ,
	email varchar(50),
	diaChi nvarchar(250),
	ngaySinh datetime ,
	gioiTinh bit default 1,
	ghiChu ntext
)
go

-- 3: Tạo Table [Articles] chứa thông tin về các bài viết phục vụ cho quảng bá sản phẩm, ------
--    xu hướng mua sắm hiện nay của người tiêu dùng , ...             ------------------------- 
create table BaiViet
(
	maBV varchar(10) primary key not null,
	tenBV nvarchar(250) not null,
	hinhDD varchar(max),
	ndTomTat nvarchar(2000),
	ngayDang datetime ,
	loaiTin nvarchar(30),
	noiDung nvarchar(4000),
	taiKhoan varchar(20) not null ,
	daDuyet bit default 0,
	foreign key (taiKhoan) references taiKhoan(taiKhoan) on update cascade 
)
go
-- 4: Tạo Table [LoaiSP] chứa thông tin loại sản phẩm, ngành hàng -----------------------------
create table LoaiSP
(
	maLoai int primary key not null ,
	tenLoai nvarchar(88) not null,
	ghiChu ntext default ''
)


--Danh sách con
create table DScon
(
	maDS int primary key not null identity,
	maLoai int foreign key references LoaiSP(maLoai),
	tenDS nvarchar(100),
)
go
--Nhãn hàng
create table nhanHang
(
	maNH int primary key not null,
	maLoai int foreign key references LoaiSP(maLoai),
	tenNH nvarchar(100),

)
go
-- 4: Tạo Table [Products] chứa thông tin của sản phẩm mà shop kinh doanh online --------------
create table SanPham
(
	maSP varchar(10) primary key not null,
	tenSP nvarchar(500) not NULL,
	hinhDD varchar(max) DEFAULT '',
	ndTomTat nvarchar(2000) DEFAULT '',
	ngayDang DATETIME DEFAULT CURRENT_TIMESTAMP,
	maLoai int not null references LoaiSP(maLoai),
	maDS int foreign key references DScon(maDS),
	maNH int foreign key references nhanHang(maNH),
	noiDung nvarchar(4000) DEFAULT '',
	taiKhoan varchar(20) not null foreign key references taiKhoan(taiKhoan) on update cascade,
	dvt nvarchar(32) default N'Cái',
	daDuyet bit default 0,
	giaBan INTEGER DEFAULT 0,
	giamGia INTEGER DEFAULT 0 CHECK (giamGia>=0 AND giamGia<=100),
	nhaSanXuat nvarchar(168) default ''
)
go

-- 5: Tạo Table [Orders] chứa danh sách đơn hàng mà khách đã đặt mua thông qua web ------------
create table DonHang
(
	soDH varchar(10) primary key not null ,
	maKH varchar(10) not null foreign key references khachHang(maKH),
	taiKhoan varchar(20) not null foreign key references taiKhoan(taiKhoan) on update cascade ,
	ngayDat datetime,
	daKichHoat bit default 1,
	ngayGH datetime,
	diaChiGH nvarchar(250),
	ghiChu ntext
)
go	

-- 6: Tạo Table [OrderDetails] chứa thông tin chi tiết của các đơn hàng ---
--    mà khách đã đặt mua với các mặt hàng cùng số lượng đã chọn ---------- 
create table CtDonHang	
(
	soDH varchar(10) not null foreign key references donHang(soDH),
	maSP varchar(10) not null foreign key references sanPham(maSP),
	soLuong int,
	giaBan bigint,
	giamGia BIGINT,
	PRIMARY KEY (soDH, maSP)
)
go
---- function tình giảm giá
create function f_giaSauGiam
(
)
returns table
as
return (
select maSP, giamoi = giaBan+giaBan*100/giamGia
from SanPham
)
/*========================== Nhập dữ liệu mẫu ==============================*/

-- YC 1: Nhập thông tin tài khoản, tối thiểu 5 thành viên sẽ dùng để làm việc với các trang: Administrative pages
insert into taiKhoan
values('admin','123',N'Dương Chí',N'Tuấn',06/12/1996,1,0935694223,'dctuan@gmail.com','472 CMT8, P.11,Q3, TP.HCM',1,'')
GO

------ nhập thông tin Loại Sp
insert into LoaiSP(TenLoai,maLoai) values
('Grocies',01),
('Household',02),   
('Personal Care',03),
('Packaged Foods',04),
('Beverages',05)
go
-----Nhập thông tin danh sách con

insert into DScon(maLoai,TenDS) values
(01,'Beans'),
(01, 'Dry Fruit'),
(01,'Canned Goods'),
--
(02, 'Cookware'),
(02, 'Dust Pans'),
(02, 'Knife' ),
--
(  03,'Baby Soap'),
(  03,'Baby Care Accessories'),
(03,'Baby Oil & Shampoos'),
--
( 04,'Snack'),
(  04,'Biscuits'),
(  04,'Breakfast Cereals'),
( 04,'Chocolates & Sweets'),
--
 (05,'Soft Drink'),
(  05,'Coffe'),
(  05,'Clean Water')
--
go
insert into SanPham(maSP, tenSP, hinhDD, ndTomTat, TaiKhoan, giaBan, giamGia, MaLoai,MaDS,dvt) values

----Danh sach con Beans-A01
              ('A011', 'Chickpeas','/Assets/images/grocies/dauHaLan.jpg', 
			  'Chickpeas are rich in nutrients, good for digestion, and prevent diabetes. Whole 
			  bean chickpeas are firm, round and not flattened, quality, imported raw materials 
			  from the US. Beans are used to cook soups, salads, stews or other dishes, quality 
			  and delicious are trusted by many people.', 'admin',5500,20,01,1,'kg'),
			  --
			  ('A012', 'Lentils','/Assets/images/grocies/20200716_012934_455507_dau-lang-la-gi-tac-.max-1800x1800.jpg', 
			  'Lentils are rich in nutrients, good for digestion, and prevent diabetes. Lentils are firm, 
			  round, and quality, and imported from the US. Beans are used to cook soup, salad, stew bones 
			  or cook other dishes, quality and delicious are many people ...', 'admin',4500,10,01,1,'kg'),
			  --
			  ('A013', 'Pea','/Assets/images/grocies/chickpeas-dau-ga-sottolesstelle.jpg', 
			  'Fatty peas, delicious fleshy flesh are carefully wrapped in a layer of crispy aromatic powder and soaked 
			  in wasabi the outside, rich in spices. Wasabi peas are convenient, delicious, suitable for snacking and 
			  watching movies, reading books.', 'admin',3500,10,01,1,'kg'),
			  --
			  ('A014', 'Kidney Bean','/Assets/images/grocies/dauThan.jpg', 
			  'Kidney beans originate from Central America and Mexico, then are grown a lot in India, Spain... Indian 
			  kidney beans are considered to be rich in nutrients, delicious, fragrant and fleshy. They contain as much 
			  protein as vegetables and are a rich source of fiber. At the same time, this legume is vegan, making it a 
			  great substitute for meat products.', 'admin',2500,10,01,1,'kg'),
			  --
			  ('A015', 'Black Beans','/Assets/images/grocies/dauDen.jpg', 
				'Black beans are green, firm, clean, and free of garbage. Green black beans are very fleshy, not flat,
				used to cook sticky rice or can be used to cook cool tea, ... and many other dishes depending on the 
				preferences of each person. Safe beans, hygienic quality are chosen by many people to buy.', 
				'admin',1500,10,01,1,'kg'),
			  --
			  ('A016', 'Soy Beans','/Assets/images/grocies/dauNanh.jpg', 
			  'Large, quality soybeans. Soybeans with the quality of large, fat beans can be used for many cooking uses 
			  such as making tea, cooking sticky rice or grinding drinking water. Dried soybeans have a long shelf life, 
			  you can buy large packages to save', 
			  'admin',500,10,01,1,'kg'),
			  --
			  ('A017', 'Pinto Beans','/Assets/images/grocies/pinto.jpg', 
			  'Pinto beans are rich in nutrients, good for digestion, and prevent diabetes. Pinto beans are firm, round, 
			  and quality, and imported from the US. Beans are used to cook soup, salad, stew bones or cook other dishes, 
			  quality and delicious are trusted by many people.', 
			  'admin',500,10,01,1,'kg'),
			  --
			  ('A018', 'Navy Beans','/Assets/images/grocies/navy.jpg', 
			  'White beans are 100% big, round, fat, quality, not mixed with garbage, grit, ... White beans are very suitable 
			  for cooking sticky rice, tea and other dishes. Quality beans, convenient for health, provide many nutrients for 
			  the body, many people choose to buy', 
			  'admin',500,10,01,1,'kg'),
			  --
			  ('A019', 'Peanut','/Assets/images/grocies/peanut.jpg', 
			  'Fatty peanuts, delicious fleshy flesh are carefully wrapped with a layer of delicious BBQ flavor and rich in 
			  spices outside. BBQ peanuts are convenient, delicious, suitable for snacking and watching movies, reading books. 
			  Peanut is a famous brand that many people trust to buy.', 
			  'admin',500,10,01,1,'kg'),
---Danh sach con Dry Fruit-A02

			  ('A021', 'Coca-Cola','/Assets/images/DryFruit/coca.jpg', 'From the world is leading 
			  soft drink brand, Coca Cola genuine soft drink Coca Cola helps to quickly dispel fatigue 
			  and stress, especially suitable for outdoor activities. Besides, the bottle design is 
			  compact, convenient and easy to store when not in use ', 'admin',50,20,01,2,'bottle'),
			  --
			  ('A022', 'C2','/Assets/images/DryFruit/c2.jpg', 'Produced from natural green tea leaves 
			  blended with fresh lemon flavor to give you a great refreshing drink. Green tea contains 
			  high levels of antioxidants and abundant vitamin C from lemons to help you stay active and 
			  excited. ', 'admin',50,20,01,2,'bottle'),
			  --
			  ('A023', 'Mirinda','/Assets/images/DryFruit/mirinda.jpg', 'Soft drinks of the Merinda brand are a 
			  great choice for you. Mirinda Soda Pet Ice Cream has a mild fragrance and sweet taste to help you 
			  dispel your thirst, awakening positive energy in you. Safe ingredients, no harmful chemicals, so 
			  you can use it with peace of mind. ', 'admin',50,20,01,2,'bottle'),
			  --
			  ('A024', 'Number One','/Assets/images/DryFruit/n1.jpg', 'Number1 brand is delicious quality energy drink. 
			  Number1 energy drink has natural ingredients, delicious and refreshing taste. The product helps the body 
			  replenish water, replenish energy, vitamins C and E, help dispel thirst and feelings of fatigue.' , 
			  'admin',50,20,01,2,'bottle'),
			  --
			  ('A025', 'Nutriboost','/Assets/images/DryFruit/nutri.jpg', 'Fruit milk is made with milk and strawberry juice 
			  to help supplement calcium for strong bones and joints. The vitamins added in Nutriboost fruit milk help protect 
			  the body, strengthen the immune system, and protect bright eyes. strong. Genuine product from Nutriboost fruit milk' , 
			  'admin',50,20,01,2,'bottle'),
			  --
			  ('A026', 'Redbull','/Assets/images/DryFruit/redbull.jpg', 'Redbull energy drink with natural ingredients, delicious 
			  and refreshing taste. Redbull energy drink helps the body replenish water, replenish energy, vitamins and minerals, 
			  help dispel thirst and feelings of fatigue. Energy drinks do not contain chemical sugar, do not contain harmful chemicals,
			  ensure safety','admin',50,20,01,2,'bottle'),
			  --
			  ('A027', 'Sting','/Assets/images/DryFruit/sting.jpg', 'Energy drink product with delicious, refreshing taste, supplemented 
			  with quality red ginseng. Sting helps the body replenish water, replenish energy, vitamins C and E, help dispel thirst and fatigue, 
			  and strawberries for lightness and comfort. Commitment to genuine, quality and safety','admin',50,20,01,2,'bottle'),
			  --
			  ('A028', 'Wake Up 247','/Assets/images/DryFruit/wk247.jpg', 'With natural ingredients that are safe for health, adding vitamins and 
			  nutrients needed by the body. Wake Up 247 energy drink has a delicious, refreshing taste with a pleasant aroma of coffee. Genuine energy 
			  drink product from energy drink brand Wake up 247','admin',50,20,01,2,'bottle'),
			  -- 
			  ('A029', 'Lavie','/Assets/images/DryFruit/lavie.jpg', 'Lavie pure water is taken from a guaranteed underground water source, filtering out 
			  impurities. Products that have reached the level of pure water usually only have the effect of quenching thirst, very easy to drink.',
			  'admin',50,20,01,2,'bottle'),
--- Danh sach con Canned Goods-A03
			('A031', 'Tuna','/Assets/images/CannedGoods/canuc.jpg', 'With 70% of the tuna meat and carefully selected vegetable oils and spices,
			 the oil-soaked tuna will help you feel the fat and sponginess of the fish meat along with the layers. delicious, exotic and convenient vegetable 
			 oil', 'admin',550,20,01,3,'canned'),
			 ----
			 ('A032', 'Pompano','/Assets/images/CannedGoods/cangudaiduong.jpg', 'Conveniently processed and canned, saving processing time for housewives. 
			 Sardines with tomato sauce have a characteristic aroma of fresh scad meat and spices. In particular, the product also has tomato sauce that brings 
			 a delicious and attractive taste.', 'admin',550,20,01,3,'canned'),
			 ----
			 ('A033', 'Blue Scaled Herring','/Assets/images/CannedGoods/catrich.jpg', 'Herring in tomato sauce is made from the freshest selection of herring, 
			 combined with tomato sauce and other wonderful spices to create a rich, irresistible dish. Perfect for cooking at home or for travel or picnics.', 
			 'admin',550,20,01,3,'canned'),
			  ----
			 ('A034', 'Yellowcheek','/Assets/images/CannedGoods/camang.jpg', 'The harmonious combination of special Spanish seasoning sauce combined with the 
			 sweet aroma of milkfish, Spanish milkfish with delicious, ecstatic, strange taste.', 
			 'admin',550,20,01,3,'canned'),
			 ---
			 ('A035', 'Marine Fish','/Assets/images/CannedGoods/cabien.jpg', 'Originated in Thailand, Oiled Sea Fish is a product that brings out the flavor of 
			 sardine. With sardine meat and vegetable oil and spices, the product will help you feel the fat and sponginess of the fish meat with a delicious and 
			 rich vegetable oil layer suitable for salads.', 'admin',550,20,01,3,'canned'),
			 ---
			 ('A036', 'Cow Or Bull ','/Assets/images/CannedGoods/thitbo.jpg', 'Ingredients include carefully selected beef, pork and other spices. With Beef in tomato sauce, you will shorten the cooking time, just reheat the canned beef before 
			use and you are ready for a delicious and nutritious dish.', 'admin',550,20,01,3,'canned'),
			 ---
			 ('A037', 'Ham ','/Assets/images/CannedGoods/thitbo.jpg', 'Delicious canned pork is made from quality pork thighs, complete with spices. Shredded ham in 340g box with convenient packaging, easy to open, compact and easy to carry around. 
			 Convenient and rich canned pork can be used with hot rice, processing delicious dishes such as salad, fried, fried, ...', 'admin',550,20,01,3,'canned'),
			 ---
			 ('A038', 'Pork ','/Assets/images/CannedGoods/thitheo.jpg', 'Canned pork is convenient, delicious and nutritious. Canned pork stew saves cooking time for busy people but still provides you and your family with delicious, quality and safe food. 
			 Canned pork is rich in spices, stimulates the taste, eats without boredom.', 'admin',550,20,01,3,'canned'),
			 ---
			 ('A039', 'Bacon ','/Assets/images/CannedGoods/thitxongkhoi.jpg', 'Delicious canned pork is made from quality chicken, pork, complete spices. Bacon with convenient packaging, easy to open, compact and easy to carry around. Convenient, rich canned 
			 pork can be used with hot rice, making delicious dishes.', 'admin',550,20,01,3,'canned')
			 
go
-----Loai Household 02
insert into sanPham (maSP, tenSP, hinhDD, ndTomTat, taiKhoan, giaBan, giamGia, maLoai,MaDS, dvt)  values
---Danh sach con Cookware
('B011','Hybrid Hobs', '/Assets/images/Cookware/bepdientu.jpg','The double induction cooker has a sophisticated and luxurious design, 
with 2 cooking zones, allowing you to cook many dishes at the same time, shortening the maximum cooking time. The cooktop is made from 
Crystal glass - China, bearing, good heat resistance. Shiny material is easy to clean, good scratch resistance, stable cooking performance 
during use.','admin', 1000,20, 02, 4,'product'),
---
('B012','Gas Stove', '/Assets/images/Cookware/bepgas.jpg','The design of the burner saves gas, giving great efficiency with a gas consumption 
of only 0.17 kg/h for the left oven and 0.22 kg/h for the right furnace. The priming gas shield helps to prevent users from using paper or 
flammable objects into the kitchen throat to ignite the stove, which can easily cause a dangerous explosion.','admin', 1500,20, 02, 4,'product'),
---
('B013','Hydroelectric Tank', '/Assets/images/Cookware/binhthuydien.jpg','Convenient keep-warm function. Keeps the water warm for longer, you can do 
other things before using the water without worrying about the water cooling down. The filter mesh at the mouth of the bottle helps to filter out 
impurities, giving fresh water, limiting sediment. Column displays water level with clear level lines, pour water into the tank exactly as needed, 
avoiding overfilling, which wastes electricity.','admin', 800,20, 02, 4,'product'),
---
('B014',' Microwave', '/Assets/images/Cookware/lovisong.jpg','Compact oven design is very convenient for installation and cleaning. Neutral gray color 
is suitable for many kitchen spaces. You can customize 1 of 3 functions of the oven: cooking, reheating and defrosting with 5 suitable power levels, up 
to 800W to save a lot of cooking time. In addition, the microwave oven also has a convenient time setting mode of up to 35 minutes, helping the food 
not be burnt or dry.','admin', 850,20, 02, 4,'product'),
---
('B015',' Coffeemaker ', '/Assets/images/Cookware/maycaphe.jpg','The anti-drip system keeps the coffee from leaking from the faucet for 1.2 - 1.5 
seconds when you remove the cup during the brewing process, convenient when you need to pour coffee continuously into many cups for many users at the 
same time, ensuring Hygiene for the area where the device is used, especially when used for public needs.','admin', 1050,20, 02, 4,'product'),
---
('B016',' Juicer ', '/Assets/images/Cookware/mayepnuoc.jpg','Modern, elegant and beautiful design in space. The body of the machine is made of high-quality 
luxury plastic that is easy to clean. You can easily put a large amount of vegetables into the machine to grind without having to chop the ingredients. The large 
diameter of the food stuffing tube allows you to squeeze the whole fruit for small and medium-sized vegetables such as carrots, strawberries, grapes...','admin', 1850,20, 02, 4,'product'),
---
('B017',' Dishwasher ', '/Assets/images/Cookware/mayruachen.jpg','The stand-alone dishwasher is designed to stand out, featuring solid silver metal, giving it a sturdy beauty and highlighting 
your interior space. Compact size, making the machine flexible when arranged, suitable for many different interior spaces, highlighting any family kitchen space. The product can be installed in 
the cabinet under the kitchen shelf (not mounted on the wall) conveniently.','admin', 2050,20, 02, 4,'product'),
---
('B018',' Pots and Pans ', '/Assets/images/Cookware/noichao.jpg','The pot with a diameter of 20 cm can be used to cook soup, hot pot, stewed dishes, ... The 26 cm diameter non-stick pan is convenient to cook stir-fry, fried, and fried 4 chicken wings at the same 
time. The handle of the pan, the pot is insulated against heat, rest assured when lifting the pot and pan from the stove','admin', 2050,20, 02, 4,'product'),
---
('B019',' Rice Cooker  ', '/Assets/images/Cookware/noicomdien.jpg','Functions include: quick cooking, cooking rice, steaming, porridge, soup, stew, cake, yogurt, warming and keeping warm, maximum support for housewive is cooking needs, serving many nutritious dishes nutrition to meet the tastes and needs of family members.','admin', 2050,20, 02, 4,'product'),

--- Danh sach con Dust Pans
('B021',' Nonstick Aluminum Pan Delites  ', '/Assets/images/DustPan/chao1.jpg','Delites nonstick pan has a diameter of 24 cm, 
frys 3 chicken wings. The pan has a beautiful design with a luxurious stone pattern and youthful colors.','admin',500,10, 02, 5,'product'),
---
('B022',' Elmich Coloseum Bottom Nonstick Aluminum Pan ', '/Assets/images/DustPan/chao2.jpg','Delites nonstick pan has a diameter of 24 cm, 
frys 3 chicken wings. The pan has a beautiful design with a luxurious stone pattern and youthful colors.','admin',520,10, 02, 5,'product'),
---
('B023',' Elmich Coloseum Bottom Nonstick Aluminum Pan ', '/Assets/images/DustPan/chao3.jpg','Convenient frying pan in the family has 4-6 members, 
frying about 6 chicken thighs at the same time. Cooking is absolutely safe for health, limiting grease, simple cleaning.','admin',550,10, 02, 5,'product'),
---
('B024',' Delites Nonstick Aluminum Pan', '/Assets/images/DustPan/chao4.jpg','With this diameter, the pan can fry 2 small fish rings. Durable, limit food fire, 
ensure health safety and hygiene after use.','admin',300,10, 02, 5,'product'),
---
('B025',' Kangaroo Nonstick Deep Aluminum Pan', '/Assets/images/DustPan/chao5.jpg','Pan made of aluminum alloy 3003, the surface is a non-stick layer of stone 
vein coated with PTFE paint subject to a maximum heat of 400 °C .Help cook safely for health, easy to clean. The mass of the pan is 0.95 kg, convenient to handle
cooking and moving.','admin',700,10, 02, 5,'product'),
---
('B026','Kangaroo stone-veined deep aluminum pan', '/Assets/images/DustPan/chao6.jpg','Easily make stir-fried or deep-fried dishes for even, beautiful crispy dishes. 
On the surface of the pan, there is a coating of small natural stone particles mixed with non-stick layer, less abrasive, good heat retention, easy cleaning.',
'admin',450,10, 02, 5,'product'),
---
('B027','Happycook Aura stone vein deep aluminum pan', '/Assets/images/DustPan/chao7.jpg','Happycook nonstick pan simple, eye-catching design with pink insulation coating, gray inside. 
Happycook nonstick pan simple, eye-catching design with pink insulation coating, gray inside',
'admin',800,10, 02, 5,'product'),
---
('B028','Bottom nonstick aluminum pan', '/Assets/images/DustPan/chao8.jpg','24 cm in diameter can fry 2-3 chicken thighs at the same time, serving well for families with 2-3 members.','admin',700,10, 02, 5,'product'),
---
('B029','Sunhouse Nonstick Aluminum Pan', '/Assets/images/DustPan/chao9.jpg','Sunhouse pan has a thickness of 1,790 mm with a simple design, suitable for use in any home 
kitchen space. Beautiful, durable, limiting food burning, easy to clean after use.',
'admin',600,10, 02, 5,'product'),
--- Danh sach con Knife
('B031','Zwilling Four Star Knife Block 7','/Assets/images/knife/dao1.jpg','Material from high quality carbon steel european standards, outstanding durability, safety and health of users. 
High-strength PP (Polypropylene) plastic knife handles.','admin',900,10, 02, 6,'product'),
---
('B032','Zwilling Professional S Knife Block 6','/Assets/images/knife/dao2.jpg','Material from high quality carbon steel european standards, outstanding durability, safety and health of users. 
High-strength PP (Polypropylene) plastic knife handles.','admin',600,10, 02, 6,'product'),
---
('B033','Zwilling Pro Knife Set 3 Items','/Assets/images/knife/dao3.jpg','The ZWILLING Pro kitchen knife set is made of specially formulated steel specifically used to cut and slice meats, fish 
and vegetables. Applying FRIODUR® Refrigeration Technology helps the blades achieve rigidity and high corrosion resistance.','admin',1000,10, 02, 6,'product'),
---
('B034','Zwilling Life 2019 Block 7 Knife Set','/Assets/images/knife/dao4.jpg','Material from high quality carbon steel european standards, outstanding durability, safety and health of users. 
High-strength PP (Polypropylene) plastic knife handles.','admin',550,10, 02, 6,'product'),
---
('B035','Zwilling Twin Cuisine Knife Set 3 Items','/Assets/images/knife/dao5.jpg','Material from high quality carbon steel european standards, outstanding durability, safety and health of users. 
High-strength PP (Polypropylene) plastic knife handles.','admin',900,10, 02, 6,'product'),
---
('B036','Zwilling Four Star Knife Set 3 Items','/Assets/images/knife/dao6.jpg','Material from high quality carbon steel european standards, outstanding durability, safety and health of users. 
High-strength PP (Polypropylene) plastic knife handles.','admin',850,10, 02, 6,'product'),
---
('B037','Zwilling Pro Knife Set 2 Items','/Assets/images/knife/dao7.jpg','The ZWILLING Pro kitchen knife set is made of specially formulated steel specifically used to cut and slice meats, fish 
and vegetables. Applying FRIODUR® Refrigeration Technology helps the blades achieve rigidity and high corrosion resistance.','admin',750,10, 02, 6,'product'),
---
('B038','Kai Shun Classic Chinese Chefs Knife','/Assets/images/knife/dao8.jpg','KAI Shun Classic is a high-end handmade knife of the Kai brand from Japan. The knife is made according to the San 
Mai technique with a core of VG-MAX steel combined with 68 layers of Damascus steel.','admin',650,10, 02, 6,'product'),
---
('B039','Kai Shun Premier Chefs Knife','/Assets/images/knife/dao9.jpg','Shun Premier is a high-end handmade knife line of Kai brand from Japan that stands out in its luxurious design and durability 
of the blades. Shun Premier knife is made according to San Mai technique with a core of VG-MAX steel combined with 68 layers of steel Shun Premier knife is made according to San Mai technique with a 
core of VG-MAX steel combined with 68 layers of steel','admin',700,10, 02, 6,'product')
go
--- Loai Personal care 03
insert into sanPham (maSP, tenSP, hinhDD, ndTomTat, taiKhoan, giaBan, giamGia, maLoai,MaDS, dvt)  values
----- babysoap
('C011','Cetaphil Baby','/Assets/images/bbsoap/bb1.jpg','It is a famous product of Galderma Group from Germany,
with ingredients containing Organic Calendula extracted from organic chamomile to soften the skin and increase 
skin elasticity, besides containing aloe vera, almond oil, vitamins E and B5 to help moisturize, fight inflammation 
and heal the skin','admin',100,10, 03, 7,'product'),
---
('C012','Johnson’s Baby top-to-toe','/Assets/images/bbsoap/bb2.jpg','With a non-spicy formula and a balanced pH, 
it will gently clean what water misses such as dirt, bacteria caused by sweat, waste products secreted on the baby 
is skin also helps protect natural moisture to bring smoothness, health to the skin and smoothness to the hair.',
'admin',90,10, 03, 7,'product'),
---
('C013','Chicco','/Assets/images/bbsoap/bb3.jpg','With natural extract ingredients such as oats to help supplement 
B vitamins, amino acids help soften hair, moisturize the skin, help heal irritated skin, redness, lactic acid and 
glycerin contained in Chicco also help balance pH effectively, in addition, the product is completely free of alcohol, 
colorants, does not spicy children is eyes, wise.',
'admin',95,10, 03, 7,'product'),
---
('C014','Lactacyd ','/Assets/images/bbsoap/bb4.jpg','Launched around August 2013, Lactacyd is a shower gel that has been 
recommended by doctors and nurses in obstetrics and pediatrics departments. Produced with a mild formula with a pH of 3.5, 
the product effectively supports the treatment of heat rash, diaper rash and dermatitis, skin infections or boils.',
'admin',105,10, 03, 7,'product'),
---
('C015','Pigeon','/Assets/images/bbsoap/bb5.jpg','The product contains moisturizing ingredients such as Jojoba oil with mild 
characteristics, suitable pH, does not irritate the skin, is easily absorbed into the skin, cleans the skin without losing the 
natural physiological oils on the skin. skin, keeping baby is skin smooth and fresh.',
'admin',205,10, 03, 7,'product'),
--- Baby Care Accessories
('C021','Medical mask VG KID','/Assets/images/babycare/bb6.jpg','VG KID mask is composed of 3 layers of primary non-woven fabric
with separate functions of each layer to provide a comprehensive shield, protecting the respiratory tract from harmful agents such 
as: dust, bacteria, and viruses. bacteria, viruses... The innermost layer uses 20gsm soft, breathable, and waterproof Polypropylene
SSS fabric. Optimized design with soft strap and shaped nose clip with 01 solid metal core to bring comfort & comfort to children 
when using.','admin',50,10, 03, 8,'product'),
----
('C022','Kissy mask','/Assets/images/babycare/bb7.jpg','Children activated fiber mask Kissy size S uses activated fibers capable of 
filtering and blocking small dust particles at micron size and especially preventing toxic gases such as CO, SO2, H2S... The product 
helps users to prevent Avoid respiratory and cardiovascular diseases, protect facial skin from ultraviolet rays that cause aging and 
pigmentation','admin',50,10, 03, 8,'product'),
---
('C023','Hat','/Assets/images/babycare/bb8.jpg','Summer is coming, moms, need to protect the children from the bright sun when going out,
so the cap is the most appropriate accessory, right?','admin',100,10, 03, 8,'product'),
----
('C024','Thermal clothing','/Assets/images/babycare/bb9.jpg','When winter comes, sore throat is the number 1 enemy of children when the 
weather turns cold. Quickly choose for your baby Nous Thermostat to keep your baby is body warm, moms.','admin',200,10, 03, 5,'product'),
---
('C025','Loudier SMILE Outfits','/Assets/images/babycare/bb10.png','In order to choose for your baby a beautiful and suitable fashion clothes, 
in addition to safe materials, funny and attractive textures that bring enjoyment to babies every time they wear them are also one of the 
essential factors. Understanding the psychology of mothers and babies, Tuticare has imported a lot of genuine fashion clothes with all designs 
and colors of many famous brands with the desire to give the baby the best. Loudier SMILE 36M Clothing Set is one of the most popular fashion 
choices for mothers in Tuticare.','admin',150,10, 03, 8,'product'),
---
('C026','Body Thighs Mère Frais Green','/Assets/images/babycare/b11.jpg','Frais fabric is considered a cooling fabric, with thousands of 
ventilation holes to bring extreme coolness to the baby and absolute softness researched by Mère. The fabric is certified by Swiss SGS to 
ensure strict criteria for the safety of babies. Frais fabric is made from natural silk fibers from oak trees, organic cotton trees - plants 
that grow naturally without chemicals. This is the most superior product for babies with outstanding properties compared to other fabrics 
such as: absolute softness, good body temperature regulation, preventing bacteria from sticking to baby clothes and skin, Good sweat absorption, 
high durability...','admin',300,10, 03, 8,'product'),
----
('C027','Goon Premium Jumbo Diapers','/Assets/images/babycare/bb12.png','With the desire to bring the best products, GOO.N is constantly researching 
and improving to launch a new product line GOO.N Premium with outstanding quality, helping to better meet the needs of consumers.','admin',199,10, 03, 
8,'product'),
----
('C028','Merries diapers','/Assets/images/babycare/b13.jpg','The wrong choice and use of diapers can cause a baby skin to become red and painful, also 
known as a diaper rash. Merries M64 diapers for babies with soft material, extremely good absorption, diaper rash surface for babies will make your baby 
play comfortably and sleep well. Merries M64 diapers are manufactured according to Japanese technology, which is safe and does not cause skin irritation 
for babies from 6kg - 11kg. From now on, the baby will always feel comfortable, cool and play all day with parents.','admin',250,10, 03, 
8,'product'),
---
('C029','Car Seat Gluck','/Assets/images/babycare/b14.jpg','Car seat Gluck ZY-02 blue is a prominent product from the famous German brand Gluck. The 
chair has a sturdy and safe design, stylish design with a variety of colors for parents to choose from. The product helps to ensure the safety of 
children against unexpected situations that may occur when traveling with the whole family by car.','admin',399,10, 03, 
8,'product'),
---
('C0210','Car Seat Gluck','/Assets/images/babycare/b15.jpg','Car seat Gluck ZY-02 blue is a prominent product from the famous German brand Gluck. The 
chair has a sturdy and safe design, stylish design with a variety of colors for parents to choose from. The product helps to ensure the safety of 
children against unexpected situations that may occur when traveling with the whole family by car.','admin',399,10, 03, 
8,'product'),
---
('C0211','Dice gnaw gums','/Assets/images/babycare/b16.jpg','Richell - Japan No. 1 prestigious brand producing products to support breast-feeding, 
bottle-feeding, Japanese-style weaning, baby care... Richell products are manufactured according to the Japanese style. Japanese standards ensure 
BPA-free safety while bringing convenience, careful care to every little detail, so it is trusted by mothers in many developed countries.','admin',
50,10, 03, 
8,'product'),
-----Baby Oil & Shampoos
('C031','Dexeryl Skin Cream','/Assets/images/babyoil/bbb1.png','In cold weather like Hanoi, the moisturizing effect of the lotion lasts up to 8 hours, 
the skin is not moldy. Dexeryl lotion is for babies from birth to adulthood and can also be used by mothers.','admin',50,10, 03, 9,'product'),
---
('C032','Arau Baby shower gel','/Assets/images/babyoil/bbb2.png','Arau Baby shower gel extracted from 100% natural herbs will bring relaxing moments 
when bathing, protecting the delicate skin of children. Leaves your baby skin clean and soft. The product does not contain additives or colorants or 
odors, ensuring absolute safety, helping mothers feel more secure when cleaning for their children.','admin',55,10, 03, 9,'product'),
---
('C033','Dodie diaper rash cream','/Assets/images/babyoil/bbb3.jpg','Dodie diaper rash cream contains up to 99% organic ingredients. Dodie diaper rash 
cream helps to effectively prevent diaper rash, soothe diaper rash and nourish baby skin from birth.','admin',70,10, 03, 9,'product'),
---
('C034','Bubchen baby shower gel','/Assets/images/babyoil/bbb4.gif','The Bubchen range of shower gels is especially high-grade, pure, for the most 
sensitive skin of babies. The product is recommended by the "Skin & Allergy Association" and rated "Excellent" by the German consumer magazine 
"OKO TEST".','admin',85,10, 03, 9,'product'),
----
('C035','Kare Cold & Flu Bath Baby Bath Oil','/Assets/images/babyoil/bbb5.jpg','Bath oil is made from pure essential oils selected by experts from 
safe medicinal herbs that have the effect of "Tan nei lei cui" especially suitable for cases of colds and colds... The product is The first choice 
for mothers when their baby has a cold, cough, runny nose every time the cold wind comes.','admin',100,10, 03, 9,'product'),
---
('C036','Johnsons baby shampoo','/Assets/images/babyoil/bbb6.jpg','Johnsons® Baby Shampoo gently cleanses the hair and scalp. As gentle as pure water,
gentle and non-irritating. As babies begin to walk and move more, their needs will change. The Active Kids™ product line is refined and gentler than adult 
products, tailored to the unique needs of children.','admin',99,10, 03, 9,'product'),
---
('C037','Massage oil and moisturizer','/Assets/images/babyoil/bbb7.jpg','Johnsons® Baby Oil - Baby massage oil with perfect moisturizing ability, suitable 
for baby massage. With more than 125 years of experience taking care of babies through generations, our product lines are not only extremely gentle for babys 
skin but also suitable for adult skin.','admin',90,10, 03, 9,'product'),
----
('C038','Body wash shower gel','/Assets/images/babyoil/bbb8.jpg','Johnsons ® Top-To-Toe™ Hair & Body Baby Bath gently cleanses babys delicate skin and is as 
gentle as pure water. Newborn skin absorbs and loses moisture faster than adult skin, so it needs a special moisturizing regimen.','admin',199,10, 03, 6,'product'),
---
('C039','Chicco shampoo','/Assets/images/babyoil/bbb9.gif','With natural extracted ingredients, Chicco Baby Moments is the perfect alternative to traditional leaf bath 
methods and is certified to be non-irritating even to babies sensitive skin.','admin',111,10, 03, 9,'product')
go
---- Loai Packaged Foods 04
insert into sanPham (maSP, tenSP, hinhDD, ndTomTat, taiKhoan, giaBan, giamGia, maLoai,MaDS, dvt)  values
---Snack
('D011','Crab Snacks','/Assets/images/Snack/sn1.jpg','Snack has a funny shape of crabs to stimulate the taste buds.
Kinh Do crab-flavored snack packed with delicious and attractive 32g is a favorite dish not only for children but also 
for adults. Snack Kinh Do quality, convenient, easy to carry for outings, is a snack to help you relax.','admin',20,1, 04, 10,'product'),
---
('D012','Chicken Flavored Noodles Snack','/Assets/images/Snack/sn2.jpg','Snack shaped like noodles with chicken flavor, Enaak Gemez snack also
brings attractive spicy food, stimulates taste and creates a very strange feeling. Enaak Chicken Flavored Noodles Snack 30g is convenient, fun 
and convenient, and safe.','admin',20,1, 04, 10,'product'),
---
('D013','Snack cheese pieces','/Assets/images/Snack/sn3.jpg','Delicious crispy snack, fragrant cheese flavor stimulates the taste buds immensely. 
Oishi cheese snack with an attractive package of 39g, suitable for watching movies, listening to music and enjoying. Snack Oishi is convenient, 
compact, easy to carry for outdoor activities.','admin',20,1, 04, 10,'product'),
---
('D014','Potato snack with seaweed flavor','/Assets/images/Snack/sn4.jpg','Delicious crispy potato snack with just the right thickness, when eaten, 
the feeling of melting in the mouth is enjoyable. Ostar seaweed-flavored potato snack 32g pack with delicious, delicious, convenient seaweed flavor,
suitable for reading, watching movies and eating. Snack OStar is a Korean brand','admin',20,1, 04, 10,'product'),
----
('D015','Salted and pepper squid snack','/Assets/images/Snack/sn5.jpg','With delicious salt and pepper squid rolls on each piece of crispy, flavorful 
snack. Poca salt and pepper roll squid snack with 35g package is suitable as a side dish to eat while watching movies and listening to music. Snack 
Poca is delicious, premium and quality, easy to carry around','admin',20,1, 04, 10,'product'),
---
('D016','Potato snack with seaweed flavor','/Assets/images/Snack/sn6.jpg','The snack is always fragrant, the potatoes are thin and crispy. Real potato taste.
Nori Lays seaweed-flavored potato snack pack 52g is very crispy, the Nori seaweed flavor is quite fragrant and rich on each piece of potato. 
Lays potato chips are well received and used by many young people for many activities','admin',20,1, 04, 10,'product'),
---
('D017','Traditional seaweed snack','/Assets/images/Snack/sn7.jpg','Delicious, crispy seaweed snacks with real seaweed. 
Traditional seaweed snack Tao Kae Noi Big Roll 3g package is delicious, nutritious, convenient, compact and easy to carry 
for camping and travel activities. Snack Tao Kae Noi is produced from Thailand','admin',20,1, 04, 10,'product'),
---
('D018','Spicy spiced squid snack','/Assets/images/Snack/sn8.jpg','The snack has a spicy taste, the perfect seasoning, and the richness of each piece of crispy,
delicious squid. Spicy spiced squid snack Bento pack 6g domestic Thailand stimulates the taste buds while eating while watching movies is great. Snack Bento is quite 
famous and well received by many people.','admin',20,1, 04, 10,'product'),
---
('D019','Salted egg potato snack','/Assets/images/Snack/sn9.jpg','Delicious potato snack, crispy and delicious, the potato flavor is also combined with the delicious 
salted egg taste. TaYo X Salted Egg Potato Snack Pack 30g salty and salty stimulates the taste buds to eat without getting bored, Snack TaYo is suitable
as a snack for the whole family, many people choose to buy.','admin',20,1, 04, 10,'product'),
---
('D0110','Squid flavored seaweed snack roll','/Assets/images/Snack/sn10.jpg','The seaweed snack is rolled up, quite crispy, very stimulating to the taste, delicious. 
Kimmy squid ink roll snack with 6g package has an attractive and fragrant squid flavor, combined with seaweed to create a strange mouth. Kimmy seaweed snack is delicious, 
attractive, suitable for children to snack on','admin',20,1, 04, 10,'product'),
---
('D0111','Special spicy squid snack','/Assets/images/Snack/sn11.jpg','With especially delicious spicy squid on each piece of crispy, flavorful snack. Special spicy squid 
snack Poca 35g package is suitable as a side dish to eat while watching movies and listening to music. Snack Poca is delicious, premium and quality,
easy to carry around','admin',20,1, 04, 10,'product'),
---
('D0112','Potato snack with sour cream flavor','/Assets/images/Snack/sn12.jpg','Lays Stax onion sour cream potato snack 160g with a unique combination of milk, cheese and other 
ingredients to create a unique and new taste of onion sour cream. Lays snack slices are made from fresh potatoes, selectively and evenly soaked with spices to create a delicious 
crispy snack.','admin',20,1, 04, 10,'product'),
-----
('D0113','Salted egg potato snack','/Assets/images/Snack/sn13.jpg','Snack cake is a delicious food that is loved by many people. Funmore salted egg potato snack 130g with a rich and
attractive flavor of salted egg and crispy crust, stimulating the taste buds of users.','admin',20,1, 04, 10,'product'),
-----
('D0114','Potato snack with shrimp flavor','/Assets/images/Snack/sn14.jpg','Snack Funmore is loved by many people because of its delicious and attractive taste. Yum Funmore shrimp-flavored 
potato snack 130g with crispy crust and salty, sour, spicy and spicy flavors mixed with taste buds right after enjoying. Enjoy snacking with friends and relatives to have more fun!',
'admin',20,1, 04, 10,'product'),
-----
('D0115','Snack sticks with coffee','/Assets/images/Snack/sn15.jpg','Delicious crispy snack sticks, fragrant coffee and coconut milk stimulate the taste extremely. Snack stick with moka coffee
and coconut milk Akiko Oishi can attractive 240g, suitable for watching movies, listening to music and enjoying. Snack Oishi is convenient, compact, easy to carry for outdoor activities.',
'admin',20,1, 04, 10,'product'),
-------Biscuits
('D021','Sugar-free cookies','/Assets/images/biscuit/bq1.jpg','Tropicana is crispy and delicious. Tropicana Slim Vanilla Sugar-Free Cookies, 200g box, delicious vanilla flavor, giving users the best quality. Sugar-free biscuits, suitable for those on a training diet and still want to snack',
'admin',30,1, 04, 11,'product'),
----
('D022','Rice cake','/Assets/images/biscuit/bq2.jpg','The product line of crispy and delicious rice cakes, for you to enjoy extremely enjoyable. Rice Fruit Cheese Rice Cake, pack of 228g, brings a richer, more attractive cheese flavor than ever. Rice Fruit Rice Cake is suitable for snacking, produced and qualified in Hong Kong.',
'admin',30,1, 04,11,'product'),
----
('D023','Cream biscuits','/Assets/images/biscuit/bq3.jpg','Biscuit is a favorite food of many people because of its delicious and attractive taste. Lotte Sand cocoa cream biscuits box 315g with soft, sweet cream inside and fragrant crust, mixed with a little bitter taste typical of cocoa to create a unique Lotte Sand cookie flavor, not boring.',
'admin',30,1, 04, 11,'product'),
---
('D024','Butter biscuits','/Assets/images/biscuit/bq4.jpg','Tatawa biscuits are made in Malaysia with quality, delicious and attractive flavor. Tatawa sugar-free butter cookies 200g box are suitable for snacks and gifts. Crispy, nutritious biscuits are chosen by many people.',
'admin',30,1, 04, 11,'product'),
---
('D025','Cocoa cookies','/Assets/images/biscuit/bq5.jpg','It is a delicious, attractive, nutritious, delicious cocoa biscuit. Bahlsen Leibniz cocoa biscuits 200g pack nutritious, give you energy to work. Bahlsen biscuit brand originated from Poland',
'admin',30,1, 04, 11,'product'),
---
('D026','Wheat crackers','/Assets/images/biscuit/bq6.jpg','Quality, delicious McVities biscuits for a nutritious meal. McVities Digestive Traditional Whole Wheat Biscuits 250g box with whole wheat, good for health and weight loss. Delicious biscuits, providing a snack to help provide energy to work effectively.',
'admin',30,1, 04, 11,'product'),
---
('D027','Animal shaped biscuits','/Assets/images/biscuit/bq7.jpg','It is an animal-shaped cookie made from milk and honey that is crispy, attractive, nutritious and delicious. Bahlsen Zoo Milk and Honey Biscuits 100g pack nutritious, give you energy to function. Bahlsen biscuit brand originated from Poland.',
'admin',30,1, 04, 11,'product'),
---
('D028','Durian sponge cake','/Assets/images/biscuit/bq8.jpg','Crispy, fluffy sponge cake is interspersed with layers of delicious durian cream. Janscorp durian sponge cake 300g box with delicious, mildly sweet taste that won not be boring when eating. Janscorp sponge cake made in Indonesia is delicious, excellent quality..',
'admin',30,1, 04, 11,'product'),
-------
('D029','Nutri-u nuts & seeds biscuits','/Assets/images/biscuit/bq9.jpg','Tatawa biscuits are made in Malaysia with quality, delicious and attractive flavor. Nutri-u nuts & seeds & seeds Tatawa biscuits 160g are suitable for snacks and gifts. Crispy, nutritious biscuits are chosen by many people.',
'admin',30,1, 04, 11,'product'),
-------
('D0210','Wheat crackers','/Assets/images/biscuit/bq10.jpg','Quality, delicious McVities biscuits for a nutritious meal. McVities Digestive Traditional Whole Wheat Biscuits 250g box with whole wheat, good for health and weight loss. Delicious biscuits, providing a snack to help provide energy to work effectively.',
'admin',30,1, 04, 11,'product'),
----Breakfast Cereals
('D031','Nestlé Honey Stars cereal','/Assets/images/breakfast/nc1.jpg','Nestlé cereals are fortified with vitamins B1, B2, B3, B6 and C that play an important role in the physical and intellectual development of children. Nestlé Honey Stars cereal box 300g stimulates appetite, cereals help metabolize energy for children to better absorb nutrition and prevent anemia in children..',
'admin',49,1, 04, 12,'product'),
---
('D032','Yumfood nutritious cereal','/Assets/images/breakfast/nc2.jpg','Yumfood nutritional cereal with a special formula low in calories, low in fat, high in fiber, helps you control your weight effectively, giving you a healthy body and slim figure. Yumfood nutritious cereal 500g package is convenient, good price, bringing valuable nutrients from cereals.',
'admin',49,1, 04, 12,'product'),
----
('D033','Kelloggs Frosties Cereal','/Assets/images/breakfast/nc4.jpg','Cereals have a natural sweetness to help your baby eat better, eat a lot without getting bored. Kelloggs Frosties cereal 300g box of corn combined with many sweet corn flavors, brings delicious, crispy cake quality that contains many good nutrients for the body from Kelloggs cereals.',
'admin',49,1, 04, 12,'product'),
---
('D034','Nutritional cereals Viet Dai','/Assets/images/breakfast/nc5.jpg','Viet Dai cereal powder is a nutritional supplement for both the elderly and children under 3 years old. Cereal flour with a rich list of ingredients, ensuring the maximum supply of nutrients. Viet Dai nutritional cereal 500g bag provides enough nutrition and energy for the body.',
'admin',49,1, 04, 12,'product'),
----
('D035','Fruit cereal','/Assets/images/breakfast/nc6.jpg','Delicious Calbee cereal, a great choice for your breakfast. Calbee fruit cereal packs 700g high nutritional content with a combination of a variety of fruits to create a safe, healthy vitamin and mineral rich cereal.',
'admin',49,1, 04, 12,'product'),
---
('D036','Nesvita Nutrition Cereal','/Assets/images/breakfast/nc3.jpg','Nesvita nutritious cereal with a special formula low in calories, low in fat, high in fiber, helps you control your weight effectively. From there, cereals help give you a healthy body and a slim, desirable figure. Nesvita nutritious cereal 400g bag delicious taste',
'admin',49,1, 04, 12,'product'),
---
('D037','MacCereal Nutrition Cereal','/Assets/images/breakfast/nc7.jpg','MacCereal nutritional cereal with a special formula low in calories, low in fat, high in fiber, helps you control your weight effectively, giving you a healthy body and a slim figure, as the. MacCereal nutritious cereal 560g bag is delicious and easy to drink',
'admin',49,1, 04, 12,'product'),
-------Chocolates & Sweets

('D041','Oreo Cake','/Assets/images/socolaAndcandy/sc1.jpg','With a layer of delicious chocolate cream, full of flavor without being bored. Oreo Cadbury chocolate pie 180g nutrition box, for those who love chocolate. Oreo chocolate cake can be given as a gift, or eaten by the family. Exceptional premium quality products.',
'admin',25,1, 04, 13,'product'),
---
('D042','Oreo Cake','/Assets/images/socolaAndcandy/sc2.jpg','With a layer of delicious chocolate cream, full of flavor without being bored. Oreo Cadbury chocolate pie 180g nutrition box, for those who love chocolate. Oreo chocolate cake can be given as a gift, or eaten by the family. Exceptional premium quality products.',
'admin',25,1, 04, 13,'product'),
---
('D043','Almond milk chocolate','/Assets/images/socolaAndcandy/sc3.jpg','Made from almond white chocolate yourt, Bernique Almond Milk Chocolate 450g box creates delicious fat, especially for those who love chocolate. Bernique Chocolate is a Malaysian product with dried fruit, milk,... giving you a sense of pleasure while eating and relaxing.',
'admin',25,1, 04, 13,'product'),
---
('D044','Almond milk chocolate','/Assets/images/socolaAndcandy/sc4.jpg','Made from almond white chocolate yourt, Bernique Almond Milk Chocolate 450g box creates delicious fat, especially for those who love chocolate. Bernique Chocolate is a Malaysian product with dried fruit, milk,... giving you a sense of pleasure while eating and relaxing.',
'admin',25,1, 04, 13,'product'),
----
('D045','Mints','/Assets/images/socolaAndcandy/cd1.jpg','Organic mint candy. Yumearth mint organic candy pack 93.6g has a funny shape, making children excited and explore. The pure white candy looks very attractive. The candy is wrapped individually for easy storage. easy after use. Children can learn and play at the same time',
'admin',25,1, 04, 13,'product'),
----
('D046','Milk candy','/Assets/images/socolaAndcandy/cd2.jpg','Hard candy with delicious, greasy milk flavor. Galatine Milk Candy, 100g pack, helps you to stimulate your taste buds and feel comfortable when eating. Galatine candies are suitable for many tastes, can be used as snacks or in birthday parties,...',
'admin',25,1, 04, 13,'product'),
----
('D047','Coffee candy','/Assets/images/socolaAndcandy/cd3.jpg','Bitter coffee hard candy combined with rich aromatic milk flavor, though opposite but blended, helps you to be more alert. KOPIKO coffee candies 600g give you the coffee aroma and bitter sweetness. KOPIKO hard candy is imported from Indonesia',
'admin',25,1, 04, 13,'product'),
----
('D048','Mashmallow','/Assets/images/socolaAndcandy/cd4.jpg','With its chewy, delicious and supple taste, it has fascinated the taste of many people. Yumearth has launched a 50g pack of Yumearth organic 4 fruit gummies to meet the needs of users. Yumearth organic 4-flavoured gummies 50g pack with funny shapes, making children excited and explore.',
'admin',25,1, 04, 13,'product')
go
---- Loai Beverages 05
insert into sanPham (maSP, tenSP, hinhDD, ndTomTat, taiKhoan, giaBan, giamGia, maLoai,MaDS, dvt)  values
---Soft Drink
			('E011', 'Coca-Cola','/Assets/images/DryFruit/coca.jpg', 'From the world is leading 
			  soft drink brand, Coca Cola genuine soft drink Coca Cola helps to quickly dispel fatigue 
			  and stress, especially suitable for outdoor activities. Besides, the bottle design is 
			  compact, convenient and easy to store when not in use ', 'admin',50,20,05,14,'bottle'),
			  --
			  ('E012', 'C2','/Assets/images/DryFruit/c2.jpg', 'Produced from natural green tea leaves 
			  blended with fresh lemon flavor to give you a great refreshing drink. Green tea contains 
			  high levels of antioxidants and abundant vitamin C from lemons to help you stay active and 
			  excited. ', 'admin',50,20,05,14,'bottle'),
			  --
			  ('E013', 'Mirinda','/Assets/images/DryFruit/mirinda.jpg', 'Soft drinks of the Merinda brand are a 
			  great choice for you. Mirinda Soda Pet Ice Cream has a mild fragrance and sweet taste to help you 
			  dispel your thirst, awakening positive energy in you. Safe ingredients, no harmful chemicals, so 
			  you can use it with peace of mind. ', 'admin',50,20,05,14,'bottle'),
			  --
			  ('E014', 'Number One','/Assets/images/DryFruit/n1.jpg', 'Number1 brand is delicious quality energy drink. 
			  Number1 energy drink has natural ingredients, delicious and refreshing taste. The product helps the body 
			  replenish water, replenish energy, vitamins C and E, help dispel thirst and feelings of fatigue.' , 
			  'admin',50,20,05,14,'bottle'),
			  --
			  ('E015', 'Nutriboost','/Assets/images/DryFruit/nutri.jpg', 'Fruit milk is made with milk and strawberry juice 
			  to help supplement calcium for strong bones and joints. The vitamins added in Nutriboost fruit milk help protect 
			  the body, strengthen the immune system, and protect bright eyes. strong. Genuine product from Nutriboost fruit milk' , 
			  'admin',50,20,05,14,'bottle'),
			  --
			  ('E016', 'Redbull','/Assets/images/DryFruit/redbull.jpg', 'Redbull energy drink with natural ingredients, delicious 
			  and refreshing taste. Redbull energy drink helps the body replenish water, replenish energy, vitamins and minerals, 
			  help dispel thirst and feelings of fatigue. Energy drinks do not contain chemical sugar, do not contain harmful chemicals,
			  ensure safety','admin',50,20,05,14,'bottle'),
			  --
			  ('E017', 'Sting','/Assets/images/DryFruit/sting.jpg', 'Energy drink product with delicious, refreshing taste, supplemented 
			  with quality red ginseng. Sting helps the body replenish water, replenish energy, vitamins C and E, help dispel thirst and fatigue, 
			  and strawberries for lightness and comfort. Commitment to genuine, quality and safety','admin',50,20,05,14,'bottle'),
			  --
			  ('E018', 'Wake Up 247','/Assets/images/DryFruit/wk247.jpg', 'With natural ingredients that are safe for health, adding vitamins and 
			  nutrients needed by the body. Wake Up 247 energy drink has a delicious, refreshing taste with a pleasant aroma of coffee. Genuine energy 
			  drink product from energy drink brand Wake up 247','admin',50,20,05,14,'bottle'),
			  -- 
			  ('E019', 'Lavie','/Assets/images/DryFruit/lavie.jpg', 'Lavie pure water is taken from a guaranteed underground water source, filtering out 
			  impurities. Products that have reached the level of pure water usually only have the effect of quenching thirst, very easy to drink.',
			  'admin',50,20,05,14,'bottle'),
			  ---------Coffe
			  ('E021', 'Instant coffee','/Assets/images/coffe/cf1.jpg', 'Nhau is known for a long time as a precious medicine in Vietnam with the use of increasing resistance and preventing cancer. The product with the rich flavor of Meet More noni coffee mixed with the mild spicy taste from the essence of fresh noni fruit is an indispensable drink for health.',
			  'admin',69,20,05,15,'product'),
			  ----
			  ('E022', 'Instant coffee','/Assets/images/coffe/cf2.jpg', 'Nhau is known for a long time as a precious medicine in Vietnam with the use of increasing resistance and preventing cancer. The product with the rich flavor of Meet More noni coffee mixed with the mild spicy taste from the essence of fresh noni fruit is an indispensable drink for health.',
			  'admin',69,20,05,15,'product'),
			  ---
			  ('E023', 'Milk ice coffe','/Assets/images/coffe/cf3.jpg', 'Instant coffee is convenient, quickly gives you a feeling of alertness, lightness and comfort to start a new day with energy. The Coffee House Iced Milk Coffee 220g is full of the essence of instant coffee The Coffee House attracts so many followers who can now enjoy it in just a few minutes at home..',
			  'admin',69,20,05,15,'product'),
			   ---
			  ('E024', 'Milk coffee','/Assets/images/coffe/cf4.jpg', 'The perfect combination between the characteristic bitter taste of coffee and the fatty flavor of milk according to H-rens very own recipe for a more balanced, milder coffee flavor that brings an unforgettable experience to the user. Products are guaranteed to be genuine, quality and safe',
			  'admin',69,20,05,15,'product'),
			   ---
			  ('E025', 'Milk coffee','/Assets/images/coffe/cf5.jpg', 'Instant coffee products are more convenient with convenient disposable 17g paper cups that still ensure the typical coffee flavor. H-ren instant coffee 3 in 1 paper cup 17g genuine H-ren instant coffee from Buon Ma Thuot coffee is rich and high quality',
			  'admin',69,20,05,15,'product'),
			    ---
			  ('E026', 'Black coffee','/Assets/images/coffe/cf6.jpg', 'IFrom delicious and quality 100% Arabica coffee beans combined with modern European technology and long-term experience from TNI King Coffee instant coffee, TNI King Coffee Espresso 250g black coffee gives you a unique flavor. rich, strong taste and a refreshing, energetic feeling',
			  'admin',69,20,05,15,'product'),
			    ---
			  ('E027', 'TNI Coffee King Coffee Golden','/Assets/images/coffe/cf7.jpg', 'Processed according to modern processes combined with specialized recipes from TNI King Coffee experts, creating quality TNI King Coffee filter coffee products, helping you to start a new day with a dynamic, inspiring feeling. Creativity for work.',
			  'admin',69,20,05,15,'product'),
			   ---------Clean Water
			   ('E031', 'Aquafina pure water','/Assets/images/clean water/cl1.jpg', 'Aquafina purified water bottle 355ml is taken from a guaranteed underground water source, filtering out impurities. Products that have reached the level of pure water usually only have the effect of quenching thirst, very easy to drink. Aquafina purified water is spring water of the famous and reliable Pepsi brand.',
			  'admin',100,20,05,16,'product'),
			  ---
			   ('E032', 'Dasani pure water','/Assets/images/clean water/cl2.jpg', 'From the underground water source through reverse osmosis system and ozone sterilization, ensuring the purity in every drop of water to help purify the perfect body of Dasani. 24 bottles of Dasani 510ml pure water when drinking has a pure and cool taste to help the body rehydrate',
			  'admin',100,20,05,16,'product'),
			    ---
			   ('E033', 'La Vie mineral water','/Assets/images/clean water/cl3.jpg', 'Produced from mineral water deep in the ground, filtered through many geological layers rich in minerals, absorbed salt, trace elements such as calcium, magnesium, potassium, sodium, bicarbonate... The product not only provides water and minerals and maintain the vitality of the body. More economical barrel form',
			  'admin',100,20,05,16,'product'),
			   ---
			   ('E034', 'Akaline I-on Life alkaline ionized drinking water','/Assets/images/clean water/cl4.jpg', 'Quality alkaline ionized drinking water product of I-on Life brand. Akaline I-on Life alkaline ionized drinking water 450ml is produced based on advanced electrolysis technology of Japan, containing alkaline ion ingredients with many good effects for health. Guaranteed genuine and safe',
			  'admin',100,20,05,16,'product'),
			    ---
			   ('E035', 'Pure Wish TH True Water','/Assets/images/clean water/cl5.jpg', 'TH True Water brands completely natural bottled drinking water. 24 bottles of TH True Water 500ml pure water from a cool, pure natural groundwater with the most modern filtration technology, optimizing water use with the highest filtration efficiency today for perfect water quality',
			  'admin',100,20,05,16,'product')
			  go
			  