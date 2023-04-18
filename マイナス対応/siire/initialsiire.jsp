<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="ww" uri="webwork" %>
<html lang="ja">
<head>
<ww:include value="'/headContent.jsp'" />
<title>仕入一覧画面</title>
    <style>
		/*覆写bootstrap的css*/
		.panel-body {
			padding: 10px 0; 
		}
		.table > tbody > tr > td {
			padding:0.5rem;
			vertical-align:middle;
		}
		.flex{
			display: flex;
		}
		.flex-left{
			flex-basis: 40rem;
		}
		.flex-right{
			flex-basis: auto;
		}
	</style>
<script language="JavaScript">
	function submitAction(pForm,action){
		pForm.action = action;
		pForm.submit();
	}
	function setValue(pForm,pValue){
		pForm.form.person_in_charge_code_input.value = pValue;
	}
</script>
</head>
<body onunload="closeSubWindow();" class="cm-no-transition cm-1-navbar">
<form name="SiireForm" method="POST">
  <header id="cm-header">
<!--     <nav class="cm-navbar cm-navbar-primary"> -->
<!--       <div class="cm-flex"> -->
<!--         <h1>仕入処理 -->
<!--           <i class="fa fa-fw fa-angle-double-right"></i> -->
<!--         </h1> -->
<!--       </div> -->

<%--       <ww:include value="'/header.jsp'"/>	 --%>
<!--     </nav> -->
  </header>
  <div id="global">
      <div class="container-fluid">
        <div class="text-center dora-form-title">
			仕入一覧画面
			<ww:include value="'/loginName.jsp'"/>     
		</div>
        <div class="panel panel-default">
          <div class="panel-body">
             
             <ww:include value="'/message.jsp'" />
            
              <div class="form-group form-inline flex">
                <div class="flex-left">
                  <label class="dora-label-left">発注番号</label>
                  <input type="text" name="form.order_no_new" value="<ww:property value='form.order_no_new'/>" maxlength="14" class="form-control" placeholder="発注番号">
                </div>
  
                <div class="flex-right">
                    <label class="dora-label-left">発注担当者</label>
					<ww:select name="'form.order_in_code_input_new'"
							   cssClass="'form-control'" 
						   	   cssStyle="'width:20rem'" 
							   list="form.order_in_namelist_new"
							   listKey="person_in_charge_code"
							   listValue="person_in_charge_name"
							   value="form.order_in_code_input_new"
							   headerKey="''"
							   headerValue="'全て'"
					>
					</ww:select>
					
                </div>
              </div>
  
              <div class="form-group form-inline">
                <label class="dora-label-left">発注日付</label>
                <input type="date" name="form.order_date_new" value="<ww:property value='form.order_date_new'/>" class="form-control">
              </div>
  
              <div class="form-group form-inline">
              	<label class="dora-label-left">得意先コード</label>
             	<input type="hidden" id="customer_code_old">							
				<input type="text" name="form.customer_code_new" id="customer_code" value="<ww:property value='form.customer_code_new'/>" maxlength="8" class="form-control" placeholder="得意先コード">
				<input type="text" name="form.customer_name_new" id="customer_name" value="<ww:property value='form.customer_name_new'/>" maxlength="60" class="form-control" style="width:40rem;" readonly>
				<ww:hidden name="'form.processing'" value="form.processing"></ww:hidden>
				<input type="button" class="btn btn-primary" value="参照" onclick="openWindowWithScrollbarGuide('initTokuisakiGuide.action?form.fieldName_code=form.customer_code_new&form.fieldName_name=form.customer_name_new&form.processing=form.processing','得意先参照',670,770)">
              </div>
  
              <div class="form-group form-inline flex">
                <div class="flex-left">
                  <label class="dora-label-left">仕入番号</label>
                  <input type="text" name="form.stock_no_new" value="<ww:property value='form.stock_no_new'/>" maxlength="14" class="form-control" placeholder="仕入番号">
                </div>
  
                <div class="flex-right">
                    <label class="dora-label-left">仕入担当者</label>
                    <ww:select name="'form.stock_in_code_input_new'"
							   cssClass="'form-control'" 
						   	   cssStyle="'width:20rem'" 
							   list="form.stock_in_namelist_new"
							   listKey="person_in_charge_code"
							   listValue="person_in_charge_name"
							   value="form.stock_in_code_input_new"
							   headerKey="''"
							   headerValue="'全て'"
					>
					</ww:select>
                </div>
              </div>
  
              <div class="form-group form-inline flex">
                <div class="flex-left">
                  <label class="dora-label-left">仕入日付</label>
                  <input type="date" name="form.stock_date_new" value="<ww:property value='form.stock_date_new'/>" class="form-control">
                </div>
                <div class="flex-right">
                    <label class="dora-label-left">月次締区分</label>
                    <ww:select name="'form.month_close_flg_input'"
				       	   cssClass="'form-control'" 
						   cssStyle="'width:20rem'" 
					       list="form.monthcloseflgList"
					       listKey="monthcloseflgid"
					       listValue="monthcloseflgname"
					       value="form.month_close_flg_input"
				       >
		    		</ww:select>
                </div>
              </div>
  
              <div class="form-group form-inline">
                <label class="dora-label-left">納品区分</label>
               	<ww:select name="'form.delivery_status_input_new'"
						   cssClass="'form-control'" 
					   	   cssStyle="'width:20rem'" 
						   list="form.delivery_status_new"
						   listKey="code_id"
						   listValue="code_value"
						   value="form.delivery_status_input_new"
						   headerKey="''"
						   headerValue="'全て'"
				>
				</ww:select>
              </div>
  
              <div class="form-group" style="margin-top:1rem;">
                <div>
                  <button type="button" class="btn btn-primary dora-sm-button" onclick="submitAction(this.form,'showSiireSearchResultAction.action?form.flag=false');">検索</button>
                </div>
              </div>
  
  			  <!-- リストコンテント --> 			  
              <div class="form-group" style="margin-top:1.75rem">
              	<ww:if test="form.customerListNew.size>0">
              		<table style="margin-top:20px">
						<tr>
							<td width="90%">　</td>
							<td nowrap><ww:property value="form.countLines"/>件中 <ww:property value="form.startLines"/> －<ww:property value="form.endLines"/>件目  </td>
							<td width="5%">　</td>
							<td nowrap>
								<ww:if test="form.previous==true">
									<a href="#" onclick="linkAction('refreshSiire.action?form.page=',-1)">前へ </a>
								</ww:if>
								<ww:else>
									<font color="gray">前へ </font>
								</ww:else>
							</td>
							<td>　</td>
							<td nowrap>
								<ww:if test="form.next==true">
									<a href="#" onclick="linkAction('refreshSiire.action?form.page=',1)">次へ </a>
								</ww:if>
								<ww:else>
									<font color="gray">次へ </font>
								</ww:else>
							</td>
						</tr>
					</table>
					
					<table class="table table-bordered table-hover">
						<tr>
		                    <td class="text-center" style="width: 25rem;">得意先</td>
		                    <td class="text-center" style="width: 10rem;">発注番号</td>
		                    <td class="text-center" style="width: 10rem;">発注日付</td>
		                    <td class="text-center" style="width: 50rem;">件名(作業期間)</td>
		                    <td class="text-center" style="width: 10rem;">外注先</td>
		                    <td class="text-center" style="width: 10rem;">納品状況</td>
		                    <td class="text-center" style="width: 10rem;">仕入日付</td>
		                    <td class="text-center" style="width: 10rem;">請求予定日</td>
		                    <td class="text-center" style="width: 10rem;">仕入番号</td>
		                    <td class="text-center" style="width: 10rem;">承認者</td>
		                    <td class="text-center" style="width: 7rem;">承認</td>
	                  </tr>
					<ww:iterator value="form.customerListNew" status="crows" id="cmodel">
						<% String trClass = ""; %>
						<ww:if test="#crows.odd == true">
							<% trClass = "success"; %>
						</ww:if>
	
						<tr class="<%=trClass%>">
							<td class="text-center" width="200" style="word-break:break-all" rowspan="<ww:property value="customerListLength"/>"><ww:property value="customer_name"/></td>
<%-- 						<ww:iterator value="#attr.cmodel.siireModelList" status="rows" id="model"> --%>	<!-- sxt 20221020 del -->
						<ww:iterator value="siireModelList" status="rows" id="model">						<!-- sxt 20221020 add -->
							<td class="text-center" rowspan="<ww:property value="stockListLength"/>"><ww:property value="order_no"/></td>
							<td class="text-center" rowspan="<ww:property value="stockListLength"/>"><ww:property value="order_date"/></td>
							<td rowspan="<ww:property value="stockListLength"/>"><ww:property value="order_name1"/> <br> (<ww:property value="work_start_date"/>～<ww:property value="work_end_date"/> )</td>
							<td rowspan="<ww:property value="stockListLength"/>"><ww:property value="out_order_name"/></td>
							<td class="text-center" rowspan="<ww:property value="stockListLength"/>"><ww:property value="delivery_status_code_name"/></td>
				
							<input type="hidden" name="StockList" value="<ww:property value="stockList"/>" />
<%-- 							<ww:iterator value="#attr.model.stockList" status="internalRows" id="smodel"> --%>	<!-- sxt 20221020 del -->
							<ww:iterator value="stockList" status="internalRows" id="smodel">						<!-- sxt 20221020 add -->
							<td class="text-center">
							<ww:if test="stock_date=='仕入作成'">	
								<ww:if test="shurui.equals(\"2\")">
<%-- 									<a href="#" onclick="linkAction('initialSiireSinki.action?form.order_no=<ww:property value="#attr.model.order_no"/>','')"> --%>	<!-- sxt 20221020 del -->
									<a href="#" onclick="linkAction('initialSiireSinki.action?form.order_no=<ww:property value="[1].order_no"/>','')">					<!-- sxt 20221020 add -->
										<ww:property value="stock_date"/></a>
								</ww:if>
								<ww:else>
<%-- 									<a href="#" onclick="linkAction('initialSiireSinki2.action?form.order_no=<ww:property value="#attr.model.order_no"/>','')"> --%>	<!-- sxt 20221020 del -->
									<a href="#" onclick="linkAction('initialSiireSinki2.action?form.order_no=<ww:property value="[1].order_no"/>','')">						<!-- sxt 20221020 add -->
										<ww:property value="stock_date"/></a>
								</ww:else>	
							</ww:if>
							<ww:else>
								<ww:property value="stock_date"/>
							</ww:else>
							</td>
							<td class="text-center"><ww:property value="option_order_date" /></td>
							<td class="text-center">
				            <ww:if test="stock_date == ''">
							    <ww:if test="shurui.equals(\"2\")">
<%-- 									<a href="#" onclick="linkAction('initialSiireSinki.action?form.stock_date=<ww:property value="option_order_date" />&form.order_no=<ww:property value="#attr.model.order_no"/>&form.option_dtl_code=<ww:property value='#attr.smodel.option_dtl_code'/>','')" > --%>	<!-- sxt 20221020 del -->
									<a href="#" onclick="linkAction('initialSiireSinki.action?form.stock_date=<ww:property value="option_order_date" />&form.order_no=<ww:property value="[1].order_no"/>&form.option_dtl_code=<ww:property value='[0].option_dtl_code'/>','')" >							<!-- sxt 20221020 add -->
							          仕入作成</a>
								</ww:if>
								<ww:else>
<%-- 									<a href="#" onclick="linkAction('initialSiireSinki2.action?form.stock_date=<ww:property value="option_order_date" />&form.order_no=<ww:property value="#attr.model.order_no"/>&form.option_dtl_code=<ww:property value='#attr.smodel.option_dtl_code'/>','')" > --%>	<!-- sxt 20221020 del -->
									<a href="#" onclick="linkAction('initialSiireSinki2.action?form.stock_date=<ww:property value="option_order_date" />&form.order_no=<ww:property value="[1].order_no"/>&form.option_dtl_code=<ww:property value='[0].option_dtl_code'/>','')" >								<!-- sxt 20221020 add -->
							          仕入作成</a>
								</ww:else>	
							</ww:if>
							<ww:elseif test="form.rw_flag.equals(\"1\") && !month_close_flg.equals(\"2\") ">
								<ww:if test="shurui.equals(\"2\")">
<%-- 									<a href="#" onclick="linkAction('initialUpdateSiire.action?form.order_no_update=<ww:property value="#attr.model.order_no"/>&form.stock_no_update=<ww:property value="stock_no"/>&form.msgId=init','')"> --%>	<!-- sxt 20221020 del -->
									<a href="#" onclick="linkAction('initialUpdateSiire.action?form.order_no_update=<ww:property value="[1].order_no"/>&form.stock_no_update=<ww:property value="stock_no"/>&form.msgId=init','')">						<!-- sxt 20221020 add -->
										<ww:property value="stock_no"/></a>
								</ww:if>
								<ww:else>
<%-- 									<a href="#" onclick="linkAction('initialUpdateSiire2.action?form.order_no_update=<ww:property value="#attr.model.order_no"/>&form.stock_no_update=<ww:property value="stock_no"/>&form.msgId=init','')"> --%>	<!-- sxt 20221020 del -->
									<a href="#" onclick="linkAction('initialUpdateSiire2.action?form.order_no_update=<ww:property value="[1].order_no"/>&form.stock_no_update=<ww:property value="stock_no"/>&form.msgId=init','')">					<!-- sxt 20221020 add -->
										<ww:property value="stock_no"/></a>
								</ww:else>
							</ww:elseif>
							<ww:else>
								<ww:if test="shurui.equals(\"2\")">
<%-- 									<a href="#" onclick="linkAction('showSiireItiran.action?form.order_no_itiran=<ww:property value="#attr.model.order_no"/>&form.stock_no_itiran=<ww:property value="stock_no"/>&form.msgId=init','')"> --%>	<!-- sxt 20221020 del -->
									<a href="#" onclick="linkAction('showSiireItiran.action?form.order_no_itiran=<ww:property value="[1].order_no"/>&form.stock_no_itiran=<ww:property value="stock_no"/>&form.msgId=init','')">					<!-- sxt 20221020 add -->
										<ww:property value="stock_no"/></a>
								</ww:if>
								<ww:else>
<%-- 									<a href="#" onclick="linkAction('showSiireItiran2.action?form.order_no_itiran=<ww:property value="#attr.model.order_no"/>&form.stock_no_itiran=<ww:property value="stock_no"/>&form.msgId=init','')"> --%>	<!-- sxt 20221020 del -->
									<a href="#" onclick="linkAction('showSiireItiran2.action?form.order_no_itiran=<ww:property value="[1].order_no"/>&form.stock_no_itiran=<ww:property value="stock_no"/>&form.msgId=init','')">					<!-- sxt 20221020 add -->
										<ww:property value="stock_no"/></a>
								</ww:else>
							</ww:else>
							
							</td>
							<td class="text-center"><ww:property value="syouninsya_name"/><br /><ww:property value="syounin_nichiji"/></td>
							<td class="text-center"><ww:property value="approval_div_code_name"/></td>
						</tr>
							
								<ww:if test="#rows.last == false">
									<tr class="<%=trClass%>">
								</ww:if>
								<ww:else>
									<ww:if test="#internalRows.last == false">
										<tr class="<%=trClass%>">
									</ww:if>
								</ww:else>
							</ww:iterator>
						</ww:iterator>
					</ww:iterator>
					</table>
					</ww:if>

                
              </div>
          </div>
        </div>
      </div>
      <ww:include value="'/footer.jsp'" />
    </div>
</form>
</body>
<ww:include value="'/footerJs.jsp'" />
	<!-- sxt 20221019 add start -->
	<script language="JavaScript">
	$(document).ready(function(){
		/* 得意先コードblurイベント*/
		$("#customer_code").blur(function(){
			var code = $("#customer_code").val();
			var codeOld = $("#customer_code_old").val();
			if (code != codeOld) {
				$.ajax({
			        type: "POST",  
			        url: "getTokuisakiList.action",
			        data: {id:code},
			        error: function (request) {  
			        	//得意先名をクリアする
			            $("#customer_name").val("");
			        },
			        success: function (data) {  
		        		//得意先の退避値をセット
			        	$("#customer_code_old").val(code);
			        	if (data == ""){
			        		//得意先名をクリアする
				            $("#customer_name").val("");
			        	} else {
				        	//得意先当名をセットする
				            $("#customer_name").val(JSON.parse(data).customer_name);	        	
			        	}
			        }
			    });	
			}
		    
	  	}); 
	});
	</script>
	<!-- sxt 20221019 add end  -->
</html>