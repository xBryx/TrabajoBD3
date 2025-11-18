using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace tarea3BD
{
    public partial class Index : System.Web.UI.Page
    {
        SqlConnection conexion;
        Usuario usuiario;
        protected void Page_Load(object sender, EventArgs e)
        {
            String sConexion = System.Configuration.ConfigurationManager.ConnectionStrings["cadenaconexion"].ConnectionString;
            conexion = new SqlConnection(sConexion);

            var datos = Cache["datosUsuario"];
                if (datos != null)
                {
                    dynamic usuario = datos;
                    Response.Write($"Usuario: {usuario.Nombre}, IP: {usuario.IP}");
                }            
                //cargarDatosPropiedadesGV();
                cambioEstadoBtn(false);
            
        }


        //Funcion que es ejecutada al presionar boton de seleccionar en el grid view
        protected void propiedadesGVRowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "Ver")
            {
                //Mostrar botones de pagar y facturas
                cambioEstadoBtn(true);
                //indice de la fila
                int index = Convert.ToInt32(e.CommandArgument);
                //Obtener la fila seleccionada
                GridViewRow row = propiedadesGV.Rows[index];

                string numPropiedad = row.Cells[0].Text;
                string nombrePropietario = row.Cells[1].Text;
                Cache.Insert("numPropiedadSeleccionada", numPropiedad, null, DateTime.Now.AddMinutes(28), TimeSpan.Zero);
                //Verificar que funciona
                Response.Write($"Clic en '{numPropiedad}' (nombre: {nombrePropietario})");

            }
        }
        protected void cargarDatosPropiedadesGV()
        {
            //Para probar el GV
            //Aquí se cargarian los datos desde la BD
            List <Propiedad>listaPropiedades = new List<Propiedad>()
            {
                new Propiedad("Juan Alberto", 5431),
                new Propiedad("Ana Valeria", 737915),
                new Propiedad("Juan Alberto", 5431),
                new Propiedad("Ana Valeria", 737915),
                new Propiedad("Juan Alberto", 5431),
                new Propiedad("Ana Valeria", 737915),
                new Propiedad("Juan Alberto", 5431),
                new Propiedad("Ana Valeria", 737915),
                new Propiedad("Juan Alberto", 5431),
                new Propiedad("Ana Valeria", 737915),
                new Propiedad("Juan Alberto", 5431),
                new Propiedad("Ana Valeria", 737915),
                new Propiedad("Juan Alberto", 5431),
                new Propiedad("Ana Valeria", 737915),
                new Propiedad("Juan Alberto", 5431),
                new Propiedad("Ana Valeria", 737915),
                new Propiedad("Juan Alberto", 5431),
                new Propiedad("Ana Valeria", 737915),
                new Propiedad("Juan Alberto", 5431),
                new Propiedad("Ana Valeria", 737915),
                new Propiedad("Juan Alberto", 5431),
                new Propiedad("Ana Valeria", 737915)
            };
            var listaOrdenada = listaPropiedades.OrderBy(x => x.nombrePropietario).ToList();
            propiedadesGV.DataSource = listaOrdenada;
            propiedadesGV.DataBind();
        }


        //Enseña o esconde los elementos en la funcion segun el parametro de entrada
        public void cambioEstadoBtn(bool estado)
        {
            btnFacPag.Enabled = estado;
            btnFacPen.Enabled = estado;
            btnPagFac.Enabled = estado;            
        }

        protected void btnPagFac_Click(object sender, EventArgs e)
        {

            var datos = Cache["numPropiedadSeleccionada"];
            Response.Write($"Propiedad seleccionada: {datos}");
        }

        
        /*Ejecuta un sp que busca la información de una propiedad a partir
          de la identificación o un número de propiedad */
        protected void btnBusqueda_Click(object sender, EventArgs e)
        {
            //Validaciones
            if(inputBusqueda.Value == "")
            {
                divInfoBusqueda.InnerText = "Inserte el valor a buscar";
                return;
            }        
            //Redirigir al tipo de búsqueda
            if (selectBusqueda.Value == "0") {
                //SP
                SqlCommand cmd = new SqlCommand("sp_Busqueda_ValorIdentidad_Propiedad", conexion);
                cmd.CommandType = CommandType.StoredProcedure;
                //Parametros de entrada SP
                cmd.Parameters.AddWithValue("@inValorIdentidad", inputBusqueda.Value);
                //Parametros de salida
                SqlParameter outMsj = new SqlParameter("@outmsj", SqlDbType.NVarChar, 100)
                { Direction = ParameterDirection.Output };
                cmd.Parameters.Add(outMsj);
                //Parametro de retorno
                SqlParameter returnParam = new SqlParameter();
                returnParam.Direction = ParameterDirection.ReturnValue;
                cmd.Parameters.Add(returnParam);
                //Poner información en GV
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);
                propiedadesGV.DataSource = dt;
                propiedadesGV.DataBind();
                //Mostrar podible error
                divInfoBusqueda.InnerText = outMsj.Value.ToString();
            }
            else
            {
                //SP
                SqlCommand cmd = new SqlCommand("sp_Busqueda_NumPropiedad_Propiedad", conexion);
                cmd.CommandType = CommandType.StoredProcedure;
                //Parametros de entrada SP
                cmd.Parameters.AddWithValue("@inNumPropiedad", inputBusqueda.Value);
                //Parametros de salida
                SqlParameter outMsj = new SqlParameter("@outmsj", SqlDbType.NVarChar, 100)
                { Direction = ParameterDirection.Output };
                cmd.Parameters.Add(outMsj);
                //Parametro de retorno
                SqlParameter returnParam = new SqlParameter();
                returnParam.Direction = ParameterDirection.ReturnValue;
                cmd.Parameters.Add(returnParam);
                //Poner información en GV
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);
                propiedadesGV.DataSource = dt;
                propiedadesGV.DataBind();
                //Mostrar podible error
                divInfoBusqueda.InnerText = outMsj.Value.ToString();
            }            
        }

        protected void btnFacPen_Click(object sender, EventArgs e)
        {
            Response.Redirect("FacturasPendientes.aspx");
        }
    }
}