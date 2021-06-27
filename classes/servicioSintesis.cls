/**
 * @description       : 
 * @author            : maguilera@labsxd.com
 * @group             : 
 * @last modified on  : 06-27-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   06-27-2021   maguilera@labsxd.com   Initial Version
**/
public class servicioSintesis {

	String idInvoiceSave;
    String descriptionMethod;
    Integer identifier;
    String operation;
    serviciosCiclosWsSintesisComBo.ciDocumentRequest documentRequest;
    serviciosCiclosWsSintesisComBo.ciItems items;
    serviciosCiclosWsSintesisComBo.ciDocumentParameters documentParameters;
    serviciosCiclosWsSintesisComBo.ciMethod method;
    serviciosCiclosWsSintesisComBo.ciParameters parameters;
    serviciosCiclosWsSintesisComBo.ciRequest request;
    List<serviciosCiclosWsSintesisComBo.ciLstItems> listItems;
    List<serviciosCiclosWsSintesisComBo.ciEntry> listEntryDP;
    List<serviciosCiclosWsSintesisComBo.ciEntry> listEntryParam;
    serviciosCiclosWsSintesisComBo.CiclosWSPort ciclosEjecutar ;
    serviciosCiclosWsSintesisComBo.ciReturn returnSintesis;
    serviciosCiclosWsSintesisComBo.ciOutputData outputData;
    serviciosCiclosWsSintesisComBo.ciFacturaResp factura;
    serviciosCiclosWsSintesisComBo.ciDatosDosificacion datosFactura;
    
    public servicioSintesis(String idInvoice){

        this.idInvoiceSave      = idInvoice;
        this.descriptionMethod  = 'FACTURA INTERNA';
        this.operation          = 'FACTURA INTERNA';
        this.identifier         = 1001;
        this.documentRequest    = new serviciosCiclosWsSintesisComBo.ciDocumentRequest();
        this.items              = new serviciosCiclosWsSintesisComBo.ciItems();
        this.documentParameters = new serviciosCiclosWsSintesisComBo.ciDocumentParameters();
        this.method             = new serviciosCiclosWsSintesisComBo.ciMethod();
        this.parameters         = new serviciosCiclosWsSintesisComBo.ciParameters();
        this.request            = new serviciosCiclosWsSintesisComBo.ciRequest();
        this.listItems          = new List<serviciosCiclosWsSintesisComBo.ciLstItems>();
        this.listEntryDP        = new List<serviciosCiclosWsSintesisComBo.ciEntry>();
        this.listEntryParam     = new List<serviciosCiclosWsSintesisComBo.ciEntry>();
        this.ciclosEjecutar     = new serviciosCiclosWsSintesisComBo.CiclosWSPort();
        this.returnSintesis     = new serviciosCiclosWsSintesisComBo.ciReturn();
        this.outputData         = new serviciosCiclosWsSintesisComBo.ciOutputData(); 
        this.factura            = new serviciosCiclosWsSintesisComBo.ciFacturaResp();
        this.datosFactura       = new serviciosCiclosWsSintesisComBo.ciDatosDosificacion();

    }
    
    
    private class ManageException extends Exception{}
    
    public void facturacionSintesis(){
        try{
            createListItems();
            createItems();
            createListEntryForDocumentParameters();
            createDocumentParameters();
            createDocumentRequest();
            createMethod();
            createListEntryForParameters();
            createParameters();
            createRequest();
            callSintesis();
            handleResponse();
            if( this.outputData.graphicRepresentation != Null ){
                generatePDF();
                saveNroFacturaAndNroAuthorization();
            }else{
                system.debug('Esta vacío el ouput!');
        	}
        }catch( Exception e ){
            throw new ManageException( e.getMessage() );
        }
        
    }

    private void createListItems(){
        
    /*LISTA DE ITEMS----------------------------------------------------------------------------------*/
        List<blng__InvoiceLine__c> lineasDeFactura = [
            SELECT blng__Quantity__c,blng__TotalAmount__c, Name ,
            	blng__Invoice__r.Numero_de_Autorizacion__c,
                blng__Invoice__r.Numero_de_Factura__c 
                	FROM blng__InvoiceLine__c
                    WHERE blng__Invoice__c =: this.idInvoiceSave
                    LIMIT 1000
        ];
        
         
        
        for(blng__InvoiceLine__c line : lineasDeFactura){

            serviciosCiclosWsSintesisComBo.ciLstItems producto = new serviciosCiclosWsSintesisComBo.ciLstItems();
            
            if(line.blng__TotalAmount__c == 0){
                 producto.montoUnitario =0.01;
        		 producto.subTotal = 1 ;
             }else{
        		producto.montoUnitario = line.blng__TotalAmount__c;
        		producto.subTotal = line.blng__TotalAmount__c ;
             }
            Integer cantidadInt = line.blng__Quantity__c.intValue();
            producto.cantidad = cantidadInt;
        	producto.descripcion = line.Name;
        	producto.item = line.Name;
        	producto.nroItem = 1;
        
        	this.listItems.add(producto);
        }
        
    }

    private void createItems(){

        this.items.lstItems = this.listItems;
        
    }

    private void createListEntryForDocumentParameters(){

        serviciosCiclosWsSintesisComBo.ciEntry CliRazonSocial = new serviciosCiclosWsSintesisComBo.ciEntry();
        CliRazonSocial.key = 'CliRazonSocial';
        CliRazonSocial.value = 'Martinc Aguilera';
        this.listEntryDP.add(CliRazonSocial);
        
        serviciosCiclosWsSintesisComBo.ciEntry CliNit = new serviciosCiclosWsSintesisComBo.ciEntry();
        CliNit.key = 'CliNit';
        CliNit.value = '123453439';
        this.listEntryDP.add(CliNit);
        
        serviciosCiclosWsSintesisComBo.ciEntry CliContrato = new serviciosCiclosWsSintesisComBo.ciEntry();
        CliContrato.key = 'CliContrato';
        CliContrato.value = '2532425';
        this.listEntryDP.add(CliContrato);
        
        serviciosCiclosWsSintesisComBo.ciEntry EmpSucursal = new serviciosCiclosWsSintesisComBo.ciEntry();
        EmpSucursal.key = 'EmpSucursal';
        EmpSucursal.value = 'Sucursal Nro. 0';
        this.listEntryDP.add(EmpSucursal);
        
        serviciosCiclosWsSintesisComBo.ciEntry EmpCasaMatriz = new serviciosCiclosWsSintesisComBo.ciEntry();
        EmpCasaMatriz.key = 'EmpCasaMatriz';
        EmpCasaMatriz.value = 'Digital TV Cable Edmund S.R.L.';
        this.listEntryDP.add(EmpCasaMatriz);
        
        serviciosCiclosWsSintesisComBo.ciEntry SerPeriodoFacturacion = new serviciosCiclosWsSintesisComBo.ciEntry();
        SerPeriodoFacturacion.key = 'SerPeriodoFacturacion';
        SerPeriodoFacturacion.value = '062021';
        this.listEntryDP.add(SerPeriodoFacturacion);
        
        serviciosCiclosWsSintesisComBo.ciEntry FFA = new serviciosCiclosWsSintesisComBo.ciEntry();
        FFA.key = 'FFA';
        FFA.value = '0';
        this.listEntryDP.add(FFA);

    }

    private void createDocumentParameters(){

        this.documentParameters.entry = this.listEntryDP;

    }
    
    private void createDocumentRequest(){

        this.documentRequest.items = this.items;    
        this.documentRequest.documentParameters = this.documentParameters;

    }
    
    private void createMethod(){
        
        this.method.description = this.descriptionMethod;
        this.method.identifier = this.identifier;
        this.method.operation = this.operation;
        this.method.documentRequest = this.documentRequest;
        
    }
    
    private void createListEntryForParameters(){
        
        serviciosCiclosWsSintesisComBo.ciEntry login = new serviciosCiclosWsSintesisComBo.ciEntry();
        login.key ='login';
        login.value='';
        this.listEntryParam.add(login);
        
        serviciosCiclosWsSintesisComBo.ciEntry password = new serviciosCiclosWsSintesisComBo.ciEntry();
        password.key ='password';
        password.value='';
        this.listEntryParam.add(password);
        
    }

    private void createParameters(){

        this.parameters.entry = this.listEntryParam;
        
    }
    
    private void createRequest(){

        this.request.addParameters = this.parameters;
        this.request.method = this.method;
    }
    
    private void callSintesis(){

        this.returnSintesis = this.ciclosEjecutar.execute(this.request);
        
    }
    
    private void handleResponse(){
        
        if( this.returnSintesis.replyMessage == 'Factura Generada' &&
         	this.returnSintesis.responseFlag == 'OK' ){

                this.outputData = this.returnSintesis.outputData;

            }else{
                
                // MANEJAR RESPUESTA DE ERROR ACÁ!
                blng__Invoice__c facturaBilling = [ SELECT Id , Subestado__c 
                                                    FROM   blng__Invoice__c
                                                    WHERE  Id =: this.idInvoiceSave
                                                    LIMIT  1];
                
                facturaBilling.Subestado__c = '	Error Sintesis';
                update facturaBilling;

            }
        
    }

    private void generatePDF(){

		String facturaBase64 = this.outputData.graphicRepresentation;
        String jsonStr = facturaBase64;
		Attachment attach = new Attachment();
        attach.contentType = 'application/pdf';
        attach.name = 'invoice.pdf';
        attach.parentId = this.idInvoiceSave;
        attach.body = EncodingUtil.base64Decode(jsonStr);
        insert attach;

        this.factura = this.outputData.factura;

    }

    private void saveNroFacturaAndNroAuthorization( ){

       this.datosFactura = this.factura.datosDosificacion;

       blng__Invoice__c facturaBilling = [ SELECT Id ,Numero_de_Autorizacion__c,Numero_de_Factura__c 
                                           FROM   blng__Invoice__c
                                           WHERE  Id =: this.idInvoiceSave
                                           LIMIT  1];

        facturaBilling.Numero_de_Autorizacion__c = datosFactura.nroAutorizacion;
        facturaBilling.Numero_de_Factura__c = datosFactura.nroFactura;
		facturaBilling.Subestado__c = 'Completada';
        update facturaBilling;

    } 
    
}