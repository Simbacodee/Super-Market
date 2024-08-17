using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace SUPERMARKET.Areas.PrivatePage.Controllers
{
    public class OrderListController : Controller
    {
        // GET: PrivatePage/OrderList
        public ActionResult Index()
        {
            return View();
        }
    }
}