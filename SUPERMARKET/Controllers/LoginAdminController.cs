using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using SUPERMARKET.Models;
namespace SUPERMARKET.Controllers
{
    public class LoginAdminController : Controller
    {
        [HttpGet]
        public ActionResult Index()
        {
            return View();
        }
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Index(string Acc, string Pass)
        {
            string mk = MaHoa.encryptSHA256(Pass);
            ///doc thong tin tai khoan qa database 
            TaiKhoan ttdn = new SieuThiConnect().TaiKhoans.Where(x => x.taiKhoan1.Equals(Acc.ToLower().Trim()) && x.matKhau.Equals(mk)).First<TaiKhoan>();
            bool isAuth = ttdn != null && ttdn.taiKhoan1.Equals(Acc.ToLower().Trim()) && ttdn.matKhau.Equals(mk);
            if (isAuth)
            {
                Session["TtDangNhap"] = ttdn;
                return RedirectToAction("Index", "Catagories", new { Area = "PrivatePage" });
            }

            return View();
        }
    }
}