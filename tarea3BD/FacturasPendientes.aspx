<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="FacturasPendientes.aspx.cs" Inherits="tarea3BD.FacturasPendientes" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
<!--Parte de grid con los datos de busqueda-->
<h3 class="text-center text-primary mb-4">Facturas Pendientes</h3>
<div class="d-flex justify-content-center card shadow-lg p-4 bg-white rounded" style="min-width: 700px; max-height: 425px; overflow-y: auto;">            
    <!--        <div style="width: 600px; height: 300px; overflow: auto;"> -->
    <asp:GridView ID="facturasGV" runat="server"
        CssClass="table table-hover table-striped align-middle text-center"
        HeaderStyle-CssClass="table-primary"
        BorderStyle="None"
        AutoGenerateColumns="False">
        <Columns>
            <asp:BoundField DataField="ConceptoCobro" HeaderText="Concepto Factura" />
            <asp:BoundField DataField="fechaFacturacion" HeaderText="Fecha Facturación" /> 
            <asp:BoundField DataField="FechaVence" HeaderText="Fecha Vencimiento" /> 
            <asp:BoundField DataField="TotalOriginal" HeaderText="Total (Sin intereses)" /> 
            <asp:BoundField DataField="TotalFinal" HeaderText="Total (Con intereses)" /> 
        </Columns>
    </asp:GridView>
</div>
    <div class="d-flex justify-content-center">
        <asp:Button class="btn btn-nvar me-2" ID="btnVolver" runat="server" Text="Volver" OnClick="btnVolver_Click"></asp:Button>
    </div>    
</asp:Content>
