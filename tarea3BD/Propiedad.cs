using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

//Clase que emula la propiedad
//*Inicialmente esta como prueba, puede que luego se borre
namespace tarea3BD
{
    public class Propiedad
    {
        public String nombrePropietario {  get; set; }
        public int numPropiedad { get; set; }
        public Propiedad(String nombrePropietario, int numPropiedad)
        {
            this.nombrePropietario = nombrePropietario;
            this.numPropiedad = numPropiedad;
        }
    }
}