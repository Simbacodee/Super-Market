using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using SUPERMARKET.Models;
namespace SUPERMARKET.Areas.PrivatePage.Controllers
{
    public class DonHuyController : Controller
    {
        private static SieuThiConnect db = new SieuThiConnect();
        // GET: PrivatePage/DonHuy
        private void Update_DaoDien()
        {
            List<DonHang> ldh = db.DonHangs.Where(x => x.daKichHoat == false).ToList<DonHang>();
            ViewData["DanhSachDh"] = ldh;
        }
        [HttpGet]
        // GET: PrivatePages/DonBiHuy
        public ActionResult Index()
        {
            Update_DaoDien();
            return View();
        }
        [HttpPost]
        public ActionResult kichHoat(string maDonHang)
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
        [HttpPost]
        public ActionResult Delete(string maDonHang)
        {
            //----Xóa bài viết--------\\
            //-b1--khai báo thằng xóa
            int xoa = int.Parse(maDonHang);
            //-b2-- gắn thằng xóa = bv
            DonHang dh = db.DonHangs.Find(xoa);
            //-b2--xóa thằng bv đi
            db.DonHangs.Remove(dh);
            //----Cập nhật vào database
            db.SaveChanges();
            //----Hiển thị lai khi đã xóa
            Update_DaoDien();
            return View("Index");
        }
    }
}