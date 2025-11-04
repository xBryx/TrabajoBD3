using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace tarea3BD
{
    public partial class Prueba : System.Web.UI.Page
    {
        Usuario usuario;
        protected void Page_Load(object sender, EventArgs e)
        {
            String token = Request.QueryString["token"];
            if (!String.IsNullOrEmpty(token))
            {
                var datos = Cache[token];
                if (datos != null)
                {
                    dynamic usuario = datos;                   
                }
            }
        }
    }
}