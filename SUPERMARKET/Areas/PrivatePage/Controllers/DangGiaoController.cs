using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using SUPERMARKET.Models;
namespace SUPERMARKET.Areas.PrivatePage.Controllers
{
    public class DangGiaoController : Controller
    {
        // GET: PrivatePage/DangGiao
        private static SieuThiConnect db = new SieuThiConnect();
        private void Update_DaoDien()
        {
            List<DonHang> ldh = db.DonHangs.Where(x => x.daKichHoat == true).ToList<DonHang>();
            ViewData["DanhSachDh"] = ldh;
        }
        [HttpGet]
        // GET: PrivatePages/DonDangGiao
        public ActionResult Index()
        {
            Update_DaoDien();
            return View();
        }
        [HttpPost]
        public ActionResult huyDon(string maDonHang)
        {
            //----Duyệt bài viết
            DonHang dh = db.DonHangs.Find(maDonHang);
            dh.daKichHoat = false;

            //----Cập nhật vào database
            db.SaveChanges();
            //----Hiển thị lai khi đã xóa
            Update_DaoDien();
            return View("Index");
        }
        [HttpPost]
        public ActionResult thanhCong(string maDonHang)
        {
            //----Duyệt bài viết
            DonHang dh = db.DonHangs.Find(maDonHang);
            dh.daKichHoat = true;

            //----Cập nhật vào database
            db.SaveChanges();
            //----Hiển thị lai khi đã xóa
            Update_DaoDien();
            return View("Index");
        }
    }
}