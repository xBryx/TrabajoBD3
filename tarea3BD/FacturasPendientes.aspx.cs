using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace tarea3BD
{
    public partial class FacturasPendientes : System.Web.UI.Page
    {
        SqlConnection conexion;
        protected void Page_Load(object sender, EventArgs e)
        {
            var datos = Cache["numPropiedadSeleccionada"];
            Response.Write($"Propiedad seleccionada: {datos}");

            String sConexion = System.Configuration.ConfigurationManager.ConnectionStrings["cadenaconexion"].ConnectionString;
            conexion = new SqlConnection(sConexion);
            //SP
            SqlCommand cmd = new SqlCommand("sp_Factura_Pendiente_Propiedad", conexion);
            cmd.CommandType = CommandType.StoredProcedure;
            //Parametros de entrada SP
            cmd.Parameters.AddWithValue("@inNumFinca", int.Parse( (string)datos));
            
            //Poner información en GV
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            da.Fill(dt);
            facturasGV.DataSource = dt;
            facturasGV.DataBind();            
        }

        protected void btnVolver_Click(object sender, EventArgs e)
        {
            Response.Redirect("Index.aspx");
        }
    }
}