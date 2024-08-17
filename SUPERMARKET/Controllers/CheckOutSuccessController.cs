using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using SUPERMARKET.Models;
namespace SUPERMARKET.Controllers
{
    public class CheckOutSuccessController : Controller
    {
        // GET: CheckOutSuccess
        public ActionResult Index()
        {
            CartShop gh = Session["GioHang"] as CartShop;
            ViewData["Cart"] = gh;
            Session["GioHang"] = new CartShop();
            return View();
        }
    }
}