using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using SUPERMARKET.Models;
namespace SUPERMARKET.Controllers
{
    public class SingleController : Controller
    {
        // GET: Single
        public ActionResult Index(string maSP)
        {
            SieuThiConnect db = new SieuThiConnect();
            /// Lấy đối tượng SP là data model
            SanPham x = db.SanPhams.Where(SP => SP.maSP.Equals(maSP)).First<SanPham>();
            ///đưa dữ liệu vào view
            ViewData["ChiTietSP"] = x;
            return View();
        }
    }
}