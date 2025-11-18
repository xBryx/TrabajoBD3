<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="Index.aspx.cs" Inherits="tarea3BD.Index" %>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <!--Parte de busqueda-->
    <div class="d-flex justify-content-center">
        <input id="inputBusqueda" type="text" placeholder="Inserte el valor a buscar" style="width: 300px;" runat="server" />
        <select id="selectBusqueda" runat="server">
            <option value="0" selected>Elija un tipo de búsqueda</option>
            <option value="0">Identifiación de propietario</option>
            <option value="1">Número de propiedad</option>
        </select>
        <asp:Button class="btn btn-nvar me-2" ID="btnBusqueda" runat="server" Text="Buscar" OnClick="btnBusqueda_Click"></asp:Button>

    </div>
    <br />
    <div runat="server" class="d-flex justify-content-center alert alert-info" id="divInfoBusqueda">
    </div>
    <br />
    <!--<div class="d-flex justify-content-center align-items-center vh-100 bg-light">-->
    <!--Centra todo el contenido-->

    <!--Parte de grid con los datos de busqueda-->
    <h3 class="text-center text-primary mb-4">Lista de Propiedades</h3>
    <div class="d-flex justify-content-center card shadow-lg p-4 bg-white rounded" style="min-width: 700px; max-height: 425px; overflow-y: auto;">
        <!--        <div style="width: 600px; height: 300px; overflow: auto;"> -->
        <asp:GridView ID="propiedadesGV" runat="server"
            CssClass="table table-hover table-striped align-middle text-center"
            HeaderStyle-CssClass="table-primary"
            BorderStyle="None"
            AutoGenerateColumns="False"
            OnRowCommand="propiedadesGVRowCommand">
            <Columns>
                <asp:BoundField DataField="numPropiedad" HeaderText="Número Propiedad" />
                <asp:BoundField DataField="nombrePropietario" HeaderText="Nombre" />
                <asp:ButtonField ButtonType="Button" Text="Seleccionar" CommandName="Ver" />
            </Columns>
        </asp:GridView>
    </div>
    <br>
    <!--</div>-->

    <!--Parte de botones con acciones de la página-->
    <div class="d-flex justify-content-center">
        <asp:Button class="btn btn-nvar me-2" ID="btnFacPen" runat="server" Text="Facturas Pendientes" OnClick="btnFacPen_Click"></asp:Button>
        <!--<asp:Button class="btn btn-nvar me-2" ID="btnFacPag" runat="server" Text="Facturas Pagadas"></asp:Button>-->
        <asp:Button class="btn btn-nvar me-2" ID="btnPagFac" runat="server" Text="Pagar Facturas" OnClick="btnPagFac_Click"></asp:Button>

        <br>
    </div>



</asp:Content>
