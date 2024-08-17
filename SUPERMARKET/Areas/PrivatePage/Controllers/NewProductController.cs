using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.IO;
using SUPERMARKET.Models;


namespace SUPERMARKET.Areas.PrivatePage.Controllers
{
    public class NewProductController : Controller
    {
        public void DangSanPham()
        {
            List<SanPham> sp = new SieuThiConnect().SanPhams.OrderBy(x => x.tenSP).ToList<SanPham>();
            ViewData["DangSp"] = sp;
        }
        // GET: PrivatePages/SanPhamMoi
        [HttpGet]
        public ActionResult Index()
        {
            //---khai báo
            SieuThiConnect sh = new SieuThiConnect();
            SanPham x = new SanPham();
            x.maSP = string.Format("{0:ddMMyyhhmm}", DateTime.Now);
            //--các loại = mặc định
            x.ngayDang = DateTime.Now;
            x.daDuyet = false;

            ViewBag.htHinh = "/Asset/Images/cay-thong-noel.jpg";
            x.nhaSanXuat = "";
            x.giamGia = 0;
            DangSanPham();
            return View(x);
        }
        [HttpPost]
        [ValidateInput(false)]
        public ActionResult Index(SanPham e, HttpPostedFileBase hinhSanPham)
        {
            try
            {
                SieuThiConnect sh = new SieuThiConnect();
                e.daDuyet = false;
                e.ngayDang = DateTime.Now;
                e.maSP = string.Format("{0:ddMMyyhh}", DateTime.Now);
                e.giamGia = 0;
                e.nhaSanXuat = "";

                if (hinhSanPham != null)
                {
                    //----lưu hình vào thư mục bài viết UwU
                    string virPath = "/Asset/Images/sanPham/"; //-- đường dẫn ảo đi đến thư mục bài viết chứa ảnh
                    string phyPath = Server.MapPath("~/" + virPath); //- Sever.MapPath chỉ ổ đĩa sever tự chọn + đường dẫn vật lí
                    string moRong = Path.GetExtension(hinhSanPham.FileName); //- phần đuôi của hình (.jpg) or (.png).v.v......
                    string fileName = "hBV" + e.maSP + moRong;
                    //---------lưu dựa vào đường dẫn----------------
                    hinhSanPham.SaveAs(phyPath + fileName); //--lưu dựa vào đường dẫn vật lí sever chứa web
                                                            //--nhận đường dẫn truy cập tới hình đã lưu dữ dựa vào domain
                    e.hinhDD = virPath + fileName; //-đường dẫn ảo theo domain
                                                   //---cập nhật hình vừa đăng lên giao diện
                    ViewBag.htHinh = e.hinhDD;
                }
                else { e.hinhDD = ""; }
                //-------thêm dữ liệu 
                sh.SanPhams.Add(e);
                //---lưu dữ liệu vừa thêm vào dataabase
                sh.SaveChanges();
                //--- nếu đăng bài thành công thì chuyển đến trang duyệt bài 
                return View();
            }
            catch
            {
                //---nếu không đăng thì 
                return View(e);
            }
        }
    }
}