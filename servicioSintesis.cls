public class servicioSintesis {
    
    serviciosCiclosWsSintesisComBo.ciDocumentRequest documentRequest = new serviciosCiclosWsSintesisComBo.ciDocumentRequest();
    serviciosCiclosWsSintesisComBo.ciItems items = new serviciosCiclosWsSintesisComBo.ciItems();
    serviciosCiclosWsSintesisComBo.ciDocumentParameters documentParameters = new serviciosCiclosWsSintesisComBo.ciDocumentParameters();
    serviciosCiclosWsSintesisComBo.ciMethod method = new serviciosCiclosWsSintesisComBo.ciMethod();
    serviciosCiclosWsSintesisComBo.ciParameters parameters = new serviciosCiclosWsSintesisComBo.ciParameters();
    serviciosCiclosWsSintesisComBo.ciRequest request = new serviciosCiclosWsSintesisComBo.ciRequest();
    String idInvoiceSave;
    public void createListItems(String idInvoice){
        this.idInvoiceSave = idInvoice;
         /*LISTA DE ITEMS----------------------------------------------------------------------------------*/
        List<blng__InvoiceLine__c> lineasDeFactura = [SELECT blng__Quantity__c,blng__TotalAmount__c, Name 
                                                       FROM blng__InvoiceLine__c
                                                       WHERE blng__Invoice__c =: idInvoice
                                                       LIMIT 1000];
        
        List<serviciosCiclosWsSintesisComBo.ciLstItems> listItems = new List<serviciosCiclosWsSintesisComBo.ciLstItems>();
        
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
        
        	listItems.add(producto);
        }
        
        createItems(listItems);
    }
    public void createItems(List<serviciosCiclosWsSintesisComBo.ciLstItems> listItems){
        
        this.items.lstItems = listItems;
        createListEntryForDocumentParameters();
        
    }
    public void createListEntryForDocumentParameters(){
        List<serviciosCiclosWsSintesisComBo.ciEntry> listEntryDP = new List<serviciosCiclosWsSintesisComBo.ciEntry>();
        
        serviciosCiclosWsSintesisComBo.ciEntry CliRazonSocial = new serviciosCiclosWsSintesisComBo.ciEntry();
        CliRazonSocial.key = 'CliRazonSocial';
        CliRazonSocial.value = 'Martinc Aguilera';
        listEntryDP.add(CliRazonSocial);
        
        serviciosCiclosWsSintesisComBo.ciEntry CliNit = new serviciosCiclosWsSintesisComBo.ciEntry();
        CliNit.key = 'CliNit';
        CliNit.value = '123453439';
        listEntryDP.add(CliNit);
        
        serviciosCiclosWsSintesisComBo.ciEntry CliContrato = new serviciosCiclosWsSintesisComBo.ciEntry();
        CliContrato.key = 'CliContrato';
        CliContrato.value = '2532425';
        listEntryDP.add(CliContrato);
        
        serviciosCiclosWsSintesisComBo.ciEntry EmpSucursal = new serviciosCiclosWsSintesisComBo.ciEntry();
        EmpSucursal.key = 'EmpSucursal';
        EmpSucursal.value = 'Sucursal Nro. 0';
        listEntryDP.add(EmpSucursal);
        
        serviciosCiclosWsSintesisComBo.ciEntry EmpCasaMatriz = new serviciosCiclosWsSintesisComBo.ciEntry();
        EmpCasaMatriz.key = 'EmpCasaMatriz';
        EmpCasaMatriz.value = 'Digital TV Cable Edmund S.R.L.';
        listEntryDP.add(EmpCasaMatriz);
        
        serviciosCiclosWsSintesisComBo.ciEntry SerPeriodoFacturacion = new serviciosCiclosWsSintesisComBo.ciEntry();
        SerPeriodoFacturacion.key = 'SerPeriodoFacturacion';
        SerPeriodoFacturacion.value = '062021';
        listEntryDP.add(SerPeriodoFacturacion);
        
        serviciosCiclosWsSintesisComBo.ciEntry FFA = new serviciosCiclosWsSintesisComBo.ciEntry();
        FFA.key = 'FFA';
        FFA.value = '0';
        listEntryDP.add(FFA);
        
		createDocumentParameters(listEntryDP);        
    }
    public void createDocumentParameters( List<serviciosCiclosWsSintesisComBo.ciEntry> listEntryDP ){
        this.documentParameters.entry = listEntryDP;
        createDocumentRequest();
    }
    public void createDocumentRequest(){
       
    this.documentRequest.items = this.items;    
	this.documentRequest.documentParameters = this.documentParameters;
    createMethod();
    }
    public void createMethod(){
        
        String descriptionMethod = 'FACTURA INTERNA';
        Integer identifier = 1001;
        String operation = 'FACTURA INTERNA';
        
        this.method.description = descriptionMethod;
        this.method.identifier = identifier;
        this.method.operation = operation;
        this.method.documentRequest = this.documentRequest;
        createListEntryForParameters();
        
    }
    
    public void createListEntryForParameters(){
        
        List<serviciosCiclosWsSintesisComBo.ciEntry> listEntryParam = new List<serviciosCiclosWsSintesisComBo.ciEntry>();
		
        serviciosCiclosWsSintesisComBo.ciEntry login = new serviciosCiclosWsSintesisComBo.ciEntry();
        login.key ='login';
        login.value='digitalTV';
        listEntryParam.add(login);
        
        serviciosCiclosWsSintesisComBo.ciEntry password = new serviciosCiclosWsSintesisComBo.ciEntry();
        password.key ='password';
        password.value='r6hTDaAMD';
        listEntryParam.add(password);
        
        createParameters(listEntryParam);
        
    }
    public void createParameters(List<serviciosCiclosWsSintesisComBo.ciEntry> listEntryParam){
        
        this.parameters.entry = listEntryParam;
        createRequest();
        
    }
    
    public void createRequest(){
        
        this.request.addParameters = this.parameters;
        this.request.method = this.method;
        callSintesis();
    }
    public void callSintesis(){
        
        serviciosCiclosWsSintesisComBo.CiclosWSPort ciclosEjecutar = new serviciosCiclosWsSintesisComBo.CiclosWSPort();
        system.debug('HOLA');
        serviciosCiclosWsSintesisComBo.ciReturn returnSintesis = new serviciosCiclosWsSintesisComBo.ciReturn();
        returnSintesis = ciclosEjecutar.execute(request);
        //system.debug( returnSintesis.replyMessage + ' '  + returnSintesis.responseFlag );
        handleResponse(returnSintesis);
        
    }
    
    public void handleResponse( serviciosCiclosWsSintesisComBo.ciReturn returnSintesis ){
        
        if( returnSintesis.replyMessage == 'Factura Generada' &&
         	returnSintesis.responseFlag == 'OK' ){
            serviciosCiclosWsSintesisComBo.ciOutputData outputData = new serviciosCiclosWsSintesisComBo.ciOutputData();
			outputData = returnSintesis.outputData;     
            //Save facturaBase64 como attatchment 
               
            String facturaBase64 = outputData.graphicRepresentation;
                String jsonStr = facturaBase64;
				Attachment attach = new Attachment();
                attach.contentType = 'application/pdf';
                attach.name = 'invoice.pdf';
                attach.parentId = this.idInvoiceSave;
                attach.body = EncodingUtil.base64Decode(jsonStr);
                insert attach;
                
           //Save facturaBase64 como attatchment    
     
			serviciosCiclosWsSintesisComBo.ciFacturaResp facturaResp = new serviciosCiclosWsSintesisComBo.ciFacturaResp();
                
            facturaResp = outputData.factura;
                
            Double importeCreditoFiscal = facturaResp.importeCreditoFiscal;
                
             system.debug('ESTA ES LA FACT BASE64 : ' + facturaBase64 );
             system.debug('ESTE ES EL IMPORTE CREDITO FISCAL: ' + importeCreditoFiscal );   
            }else{
                system.debug(returnSintesis.replyMessage);
                system.debug(returnSintesis.responseFlag);
                // MANEJAR RESPUESTA DE ERROR ACÁ!
            }
        
    }
    
}