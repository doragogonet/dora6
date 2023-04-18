<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="ww" uri="webwork" %>
<html lang="ja">
<head>
<ww:include value="'/headContent.jsp'" />
<title>売上一覧画面</title>
  <style>
    /*覆写bootstrap的css*/
    .panel-body {
      padding: 10px 0;
    }

    .table>tbody>tr>td {
      padding: 0.5rem;
      vertical-align: middle;
    }

    .flex {
      display: flex;
    }

    .flex-left {
      flex-basis: 40rem;
    }

    .flex-right {
      flex-basis: auto;
    }
  </style>
	<script language="JavaScript">
		function submitAction(pForm,action){
			pForm.action = action;
			pForm.submit();
		}
	</script>
</head>

<body onunload="closeSubWindow();" class="cm-no-transition cm-1-navbar">

<form name="uriageform" method="post">
  <header id="cm-header">
<!--     <nav class="cm-navbar cm-navbar-primary"> -->
<!--       <div class="cm-flex"> -->
<!--         <h1>売上処理 -->
<!--           <i class="fa fa-fw fa-angle-double-right"></i> -->
<!--         </h1> -->
<!--       </div> -->
<%--       <ww:include value="'/header.jsp'"/>	 --%>
<!--     </nav> -->
  </header>
  <div id="global">
    <div class="container-fluid">
      <div class="text-center dora-form-title">
        売上一覧画面
        <ww:include value="'/loginName.jsp'"/>
      </div>
      <div class="panel panel-default">
        <div class="panel-body">
        	<ww:include value="'/message.jsp'" />
            
            <div class="form-group form-inline">
              <div class="flex">
                <div class="flex-left">
                  <label for="estimate_date" class="dora-label-left">受注番号</label>
                  <input type="text" name="form.received_no" value="<ww:property value='form.received_no'/>" maxlength="30" class="form-control" placeholder="受注番号">
                </div>
                <div class="flex-right">
                  <label for="estimate_date" class="dora-label-left">受注担当者</label>
                  <ww:select name="'form.received_in_name'"
					       cssClass="'form-control'" 
						   cssStyle="'width:20rem'" 
					       list="form.receivedInNameList" 
					       listKey="person_in_charge_code" 
					       listValue="person_in_charge_name" 
					       value="form.received_in_name" 
					       headerKey="''"
					       headerValue="'全て'">
			    </ww:select>
                </div>
              </div>
            </div>
  
            <div class="form-group form-inline">
              <label for="estimate_date" class="dora-label-left">受注日付</label>
              <input type="date" name="form.received_date" value="<ww:property value='form.received_date'/>" class="form-control">
            </div>
  
            <div class="form-inline form-group">
              	<label for="estimate_date" class="dora-label-left">得意先コード</label>
             	<input type="hidden" id="customer_code_old">							
				<input type="text" name="form.customer_code" id="customer_code" value="<ww:property value='form.customer_code'/>" maxlength="8" class="form-control" placeholder="得意先コード">
				<input type="text" name="form.customer_name" id="customer_name" value="<ww:property value='form.customer_name'/>" maxlength="60" class="form-control" style="width:40rem;" readonly>
				<ww:hidden name="'form.processing'" value="form.processing"></ww:hidden>
				<input type="button" class="btn btn-primary" value="参照" onclick="openWindowWithScrollbarGuide('initTokuisakiGuide.action?form.fieldName_code=form.customer_code&form.fieldName_name=form.customer_name&form.processing=form.processing','得意先参照',670,770)">
            </div>
  
            <div class="form-group form-inline">
              <div class="flex">
                <div class="flex-left">
                  <label for="estimate_date" class="dora-label-left">売上番号</label>
                  <input type="text" name="form.sales_no_input" value="<ww:property value='form.sales_no_input'/>" maxlength="30" class="form-control" placeholder="売上番号">
                </div>
                <div class="flex-right">
                  <label for="estimate_date" class="dora-label-left">売上担当者</label>
                  <ww:select name="'form.sales_in_name'"
					       cssClass="'form-control'" 
						   cssStyle="'width:20rem'" 
					       list="form.receivedInNameList" 
					       listKey="person_in_charge_code" 
					       listValue="person_in_charge_name" 
					       value="form.sales_in_name" 
					       headerKey="''"
					       headerValue="'全て'">
			    </ww:select>
                </div>
              </div>
            </div>
  
            <div class="form-group form-inline">
              <div class="flex">
                <div class="flex-left">
                  <label for="estimate_date" class="dora-label-left">売上日付</label>
                  <input type="date" name="form.sales_date" value="<ww:property value='form.sales_date'/>" class="form-control">
                </div>
                <div class="flex-right">
                  <label for="estimate_date" class="dora-label-left">月次締区分</label>
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
            </div>
            <!-- sxt 20221019 del start -->
<!--             <div class="form-group form-inline"> -->
<!--                 <label for="estimate_date" class="dora-label-left">請求先コード</label>              -->
<!--                 <input type="hidden" id="order_first_code_old">							 -->
<%-- 				<input type="text" name="form.order_first_code" id="order_first_code" value="<ww:property value='form.order_first_code'/>" maxlength="8" class="form-control" placeholder="請求先コード"> --%>
<%-- 				<input type="text" name="form.order_first_name" id="order_first_name" value="<ww:property value='form.order_first_name'/>" maxlength="60" class="form-control" style="width:40rem;" readonly> --%>
<!-- 				<input type="button" class="btn btn-primary" value="参照" onclick="openWindowWithScrollbarGuide('initSeikyuusakiGuide.action?form.fieldName_code=form.order_first_code&form.fieldName_name=form.order_first_name&form.processing=form.processing','請求先参照',670,770)" /> -->
<!--             </div> -->
            <!-- sxt 20221019 del end -->
  
            <div class="form-group" style="margin-top:1rem;">
              <div>
                <button type="button" class="btn btn-primary dora-sm-button" onclick="submitAction(this.form,'showUriage.action');">検索</button>
              </div>
            </div>
  
            <div class="form-group" style="margin-top:1.75rem">
              <ww:if test="form.customerList.size>0">
                <table style="margin-top:20px">
					<tr>
						<td width="90%">　</td>
						<td nowrap><ww:property value="form.countLines"/>件中 <ww:property value="form.startLines"/> －<ww:property value="form.endLines"/>件目  </td>
						<td width="5%">　</td>
						<td nowrap>
							<ww:if test="form.previous==true">
								<a href="#" onclick="linkAction('refreshUriage.action?form.page=',-1)">前へ </a>
							</ww:if>
							<ww:else>
								<font color="gray">前へ </font>
							</ww:else>
						</td>
						<td>　</td>
						<td nowrap>
							<ww:if test="form.next==true">
								<a href="#" onclick="linkAction('refreshUriage.action?form.page=',1)">次へ </a>
							</ww:if>
							<ww:else>
								<font color="gray">次へ </font>
							</ww:else>
						</td>
					</tr>
				</table>
				
				<table class="table table-bordered table-hover">
					<thead>
	                  <tr>
	                    <td class="text-center" style="width: 25rem;">得意先</td>
	                    <td class="text-center" style="width: 10rem;">受注番号</td>
	                    <td class="text-center" style="width: 10rem;">受注日付</td>
	                    <td class="text-center" style="width: 50rem;">件名(作業期間)</td>
	                    <td class="text-center" style="width: 10rem;">(請求締日)<br>(請求区分)</td>
	                    <td class="text-center" style="width: 10rem;">売上日付</td>
	                    <td class="text-center" style="width: 10rem;">請求予定日</td>
	                    <td class="text-center" style="width: 10rem;">売上番号</td>
	                    <td class="text-center" style="width: 10rem;">承認者</td>
	                    <td class="text-center" style="width: 7rem;">承認</td>
	                  </tr>
	                </thead>
	                <tbody>
	                	
						<ww:iterator value="form.customerList" status="crows" id="cmodel">
							<% String trClass = ""; %>
							<ww:if test="#crows.odd == true">
								<% trClass = "success"; %>
							</ww:if>
							<tr class="<%=trClass%>">
								<td class="text-center" style="vertical-align:middle;" rowspan="<ww:property value="customerListLength"/>"><ww:property value="customer_name"/></td>
<%-- 							    <ww:iterator value="#attr.cmodel.disCusList" status="rows" id="model"> --%>	<!-- sxt 20221019 del -->
							    <ww:iterator value="disCusList" status="rows" id="model">						<!-- sxt 20221019 add -->
								<td class="text-center" rowspan="<ww:property value="salesListLength"/>"><ww:property value="receive_no"/></td>
								<td class="text-center" rowspan="<ww:property value="salesListLength"/>"><ww:property value="receive_date"/></td>
								<td style="word-break:break-all" rowspan="<ww:property value="salesListLength"/>"><ww:property value="receive_name1"/><br>(<ww:property value="work_start_date"/>～<ww:property value="work_end_date"/>)</td>
								<td style="word-break:break-all" rowspan="<ww:property value="salesListLength"/>">(<ww:property value="balance_date"/>)(<ww:property value="order_div_name"/>)</td>
								<input type="hidden" name="delivery_status" value="<ww:property value="delivery_status"/>" />			
<%-- 								<ww:iterator value="#attr.model.salesList" status="internalRows" id="smodel"> --%>	<!-- sxt 20221019 del -->
								<ww:iterator value="salesList" status="internalRows" id="smodel">						<!-- sxt 20221019 add -->
								<ww:if test="sales_date == '売上作成'">
									<td class="text-center">
										<ww:if test="form.rw_flg.equals(\"1\")">
											<ww:if test="shurui.equals(\"2\")">
<%-- 												<a href="#" onclick="hrefHaveParamAction('newUriage.action?form.prepage=99&form.received_no_input=<ww:property value='#attr.model.receive_no'/>&form.option_dtl_code=<ww:property value='#attr.smodel.option_dtl_code'/>');"> --%>	<!-- sxt 20221019 del -->
												<a href="#" onclick="hrefHaveParamAction('newUriage.action?form.prepage=99&form.received_no_input=<ww:property value='[1].receive_no'/>&form.option_dtl_code=<ww:property value='[0].option_dtl_code'/>');">							<!-- sxt 20221019 add -->
													<ww:property value="sales_date"/>
												</a>
											</ww:if>
											<ww:else>
<%-- 												<a href="#" onclick="hrefHaveParamAction('newUriage2.action?form.prepage=99&form.received_no_input=<ww:property value='#attr.model.receive_no'/>&form.option_dtl_code=<ww:property value='#attr.smodel.option_dtl_code'/>');"> --%>	<!-- sxt 20221019 del -->
												<a href="#" onclick="hrefHaveParamAction('newUriage2.action?form.prepage=99&form.received_no_input=<ww:property value='[1].receive_no'/>&form.option_dtl_code=<ww:property value='[0].option_dtl_code'/>');">							<!-- sxt 20221019 add -->
													<ww:property value="sales_date"/>
												</a>
											</ww:else>								
										</ww:if>
										<ww:else>
											<ww:property value="sales_date"/>
										</ww:else>
									</td>	
								</ww:if>
								<!-- sxt 20220825 del start -->
<%-- 								<ww:elseif test="sales_date == '月数'"> --%>
<!-- 									<td class="text-center"> -->
<%-- 									<ww:if test="form.rw_flg.equals(\"1\")"> --%>
<%-- 										<ww:iterator value="#attr.smodel.nosales_date" status="monthcnt"> --%>
<%-- 											<ww:if test="#monthcnt.index < 3"> --%>
<%-- 											<a href="#" onclick="hrefHaveParamAction('newUriage.action?form.prepage=99&form.received_no_input=<ww:property value='#attr.model.receive_no'/>&form.nosales_month=<ww:property />');"> --%>
<%-- 											<ww:property value="#attr.smodel.nosales_date[#monthcnt.index].substring(4, 6)" />月</a>&nbsp;&nbsp; --%>
<%-- 											</ww:if> --%>
<%-- 											<ww:elseif test="#monthcnt.index == 3"> --%>
<!-- 											... -->
<%-- 											</ww:elseif> --%>
<%-- 											<ww:else></ww:else> --%>
<%-- 										</ww:iterator> --%>
<%-- 									</ww:if> --%>
<!-- 									</td> -->
<%-- 								</ww:elseif> --%>
								<!-- sxt 20220825 del end -->
								<ww:else>
								<td class="text-center"><ww:property value="sales_date"/></td>				
								</ww:else>
								<td class="text-center"><ww:property value="option_order_date" /></td>
								<td class="text-center">
									<ww:if test="sales_date == ''">
										<ww:if test="shurui.equals(\"2\")">
<%-- 											<a href="#" onclick="hrefHaveParamAction('newUriage.action?form.sales_date_input=<ww:property value='option_order_date'/>&form.prepage=99&form.received_no_input=<ww:property value='#attr.model.receive_no'/>&form.option_dtl_code=<ww:property value='#attr.smodel.option_dtl_code'/>');"> --%>	<!-- sxt 20221019 del -->
											<a href="#" onclick="hrefHaveParamAction('newUriage.action?form.sales_date_input=<ww:property value='option_order_date'/>&form.prepage=99&form.received_no_input=<ww:property value='[1].receive_no'/>&form.option_dtl_code=<ww:property value='[0].option_dtl_code'/>');">								<!-- sxt 20221019 add -->
												売上作成</a>
										</ww:if>
										<ww:else>
<%-- 											<a href="#" onclick="hrefHaveParamAction('newUriage2.action?form.sales_date_input=<ww:property value='option_order_date'/>&form.prepage=99&form.received_no_input=<ww:property value='#attr.model.receive_no'/>&form.option_dtl_code=<ww:property value='#attr.smodel.option_dtl_code'/>');"> --%>	<!-- sxt 20221019 del -->
											<a href="#" onclick="hrefHaveParamAction('newUriage2.action?form.sales_date_input=<ww:property value='option_order_date'/>&form.prepage=99&form.received_no_input=<ww:property value='[1].receive_no'/>&form.option_dtl_code=<ww:property value='[0].option_dtl_code'/>');">							<!-- sxt 20221019 add -->
												売上作成</a>
										</ww:else>
									</ww:if>
									<ww:elseif test="form.rw_flg.equals(\"1\") ">
<%-- 										<ww:if test="#attr.smodel.month_close_flg.equals(\"2\") ">	 --%>	<!-- sxt 20221020 del -->
										<ww:if test="[0].month_close_flg.equals(\"2\") ">						<!-- sxt 20221020 add -->
											<ww:if test="shurui.equals(\"2\")">
<%-- 												<a href="#" onclick="hrefHaveParamAction('infoUriage.action?form.prepage=99&form.sales_no=<ww:property value='#attr.smodel.sales_no'/>');"> --%>		<!-- sxt 20221019 del -->
												<a href="#" onclick="hrefHaveParamAction('infoUriage.action?form.prepage=99&form.sales_no=<ww:property value='[0].sales_no'/>');">							<!-- sxt 20221019 add -->
											</ww:if>
											<ww:else>
<%-- 												<a href="#" onclick="hrefHaveParamAction('infoUriage2.action?form.prepage=99&form.sales_no=<ww:property value='#attr.smodel.sales_no'/>');"> --%>		<!-- sxt 20221019 del -->
												<a href="#" onclick="hrefHaveParamAction('infoUriage2.action?form.prepage=99&form.sales_no=<ww:property value='[0].sales_no'/>');">							<!-- sxt 20221019 add -->
											</ww:else>
										</ww:if>
										<ww:else>
											<ww:if test="shurui.equals(\"2\")">
<%-- 												<a href="#" onclick="hrefHaveParamAction('editUriage.action?form.prepage=99&form.sales_no=<ww:property value='#attr.smodel.sales_no'/>');"> --%>		<!-- sxt 20221019 del -->
												<a href="#" onclick="hrefHaveParamAction('editUriage.action?form.prepage=99&form.sales_no=<ww:property value='[0].sales_no'/>');">							<!-- sxt 20221019 add -->
											</ww:if>
											<ww:else>
<%-- 												<a href="#" onclick="hrefHaveParamAction('editUriage2.action?form.prepage=99&form.sales_no=<ww:property value='#attr.smodel.sales_no'/>');"> --%>		<!-- sxt 20221019 del -->
												<a href="#" onclick="hrefHaveParamAction('editUriage2.action?form.prepage=99&form.sales_no=<ww:property value='[0].sales_no'/>');">							<!-- sxt 20221019 add -->
											</ww:else>	
										</ww:else>
										<ww:property value="sales_no"/></a>
									</ww:elseif>
									<ww:else>
										<ww:if test="shurui.equals(\"2\")">
<%-- 											<a href="#" onclick="hrefHaveParamAction('infoUriage.action?form.prepage=99&form.sales_no=<ww:property value='#attr.smodel.sales_no'/>');"> --%>			<!-- sxt 20221019 del -->
											<a href="#" onclick="hrefHaveParamAction('infoUriage.action?form.prepage=99&form.sales_no=<ww:property value='[0].sales_no'/>');">								<!-- sxt 20221019 add -->
											<ww:property value="sales_no"/></a>
										</ww:if>
										<ww:else>
<%-- 											<a href="#" onclick="hrefHaveParamAction('infoUriage2.action?form.prepage=99&form.sales_no=<ww:property value='#attr.smodel.sales_no'/>');"> --%>			<!-- sxt 20221019 del -->
											<a href="#" onclick="hrefHaveParamAction('infoUriage2.action?form.prepage=99&form.sales_no=<ww:property value='[0].sales_no'/>');">								<!-- sxt 20221019 add -->
											<ww:property value="sales_no"/></a>
										</ww:else>
									</ww:else>
								</td>
								<td class="text-center"><ww:property value="syouninsya_name"/><br /><ww:property value="syounin_nichiji"/></td>
								<ww:if test="approval_div == '03'">
									<td class="text-center">
									<ww:if test="sales_date == ''">
									&nbsp;
									</ww:if>
<%-- 									<ww:elseif test="#attr.smodel.month_close_flg.equals(\"1\") "> --%>	<!-- sxt 20221020 del -->
									<ww:elseif test="[0].month_close_flg.equals(\"1\") ">					<!-- sxt 20221020 add -->
										<input type="button" class="btn btn-primary"
											 value="印  刷" onclick="openWindowResizable('uriagePrint.action?form.sales_no=<ww:property value='sales_no'/>&form.shurui=<ww:property value='shurui'/>','印刷',800,600);"/>
									</ww:elseif>
<%-- 									<ww:elseif test="#attr.smodel.month_close_flg.equals(\"2\") "> --%>	<!-- sxt 20221020 del -->
									<ww:elseif test="[0].month_close_flg.equals(\"2\") ">					<!-- sxt 20221020 add -->
										<input type="button" class="btn btn-primary" 
											value="再印刷" onclick="openWindowResizable('uriagePrint.action?form.sales_no=<ww:property value='sales_no'/>&form.shurui=<ww:property value='shurui'/>','印刷',800,600);"/>
									</ww:elseif>
									<ww:else>
									OK
									</ww:else>
									</td>
								</ww:if>
								<ww:else>
									<td class="text-center">
										<ww:if test="sales_date == ''">
										&nbsp;
										</ww:if>
										<ww:else>
										<ww:property value="approval_div_code_name"/>
										</ww:else>
									</td>
								</ww:else>
<%-- 								<ww:if test="approval_div == '03'"> --%>
<!-- 									<td class="text-center"> -->
<%-- 									<ww:if test="sales_date == ''"> --%>
<!-- 									&nbsp; -->
<%-- 									</ww:if> --%>
<%-- 									<ww:elseif test="#attr.smodel.month_close_flg.equals(\"1\") "> --%>
<%-- 										<ww:if test="server_ip.equals('') == false"> --%>
<%-- 										<input type="button" class="button" style="width:50px" value="送  信" onclick="window.open('sendseikyu.action?form.sales_no=<ww:property value='sales_no'/>');"/> --%>
<%-- 										</ww:if> --%>
<%-- 									</ww:elseif> --%>
<%-- 									<ww:elseif test="#attr.smodel.month_close_flg.equals(\"2\") "> --%>
<%-- 										<ww:if test="server_ip.equals('') == false"> --%>
<%-- 										<input type="button" class="button" style="width:50px" value="送  信" onclick="window.open('sendseikyu.action?form.sales_no=<ww:property value='sales_no'/>');"/> --%>
<%-- 										</ww:if> --%>
<%-- 									</ww:elseif> --%>
<%-- 									<ww:else> --%>
									
<%-- 									</ww:else> --%>
<!-- 									</td> -->
<%-- 								</ww:if> --%>
								<ww:else>
									<td class="text-center">
									
									</td>
								</ww:else>
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
	                </tbody>
				</table>
				
              </ww:if>	
              
            </div>
        </div>
      </div>
    </div>
    <ww:include value="'/footer.jsp'" />
  </div>
</form>
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
</body>

</html>
