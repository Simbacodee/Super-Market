using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using SUPERMARKET.Models;
namespace SUPERMARKET.Controllers
{
    public class HomeController : Controller
    {
        public ActionResult Index()
        {
            string testMk = MaHoa.encryptSHA256("123");

            return View();
        }
        public ActionResult AddToCart(string maSP)
        {
            CartShop gh = Session["GioHang"] as CartShop;
            gh.addItem(maSP);
            Session["GioHang"] = gh;
            return View("Index");
        }

    }
}