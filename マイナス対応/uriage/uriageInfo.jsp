<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="ww" uri="webwork" %>
<html lang="ja">
<head>
<ww:include value="'/headContent.jsp'" />
<title>
	<ww:if test="form.prepage.equals(\"3\")">
	売上（請負）承認画面 			
   	</ww:if>
  	<ww:else>
  	売上（請負）照会画面 	     
  	</ww:else> 
</title>
</head>

<body class="cm-no-transition cm-1-navbar">
<form name="uriageform" method="post" class="form-horizontal">
	<header id="cm-header">
<!--        <nav class="cm-navbar cm-navbar-primary"> -->
<!--          <div class="cm-flex"> -->
<!--            <h1>日次処理 -->
<!--              <i class="fa fa-fw fa-angle-double-right"></i>  -->
<!--            </h1> -->
<!--          </div> -->
<%--          <ww:include value="'/header.jsp'"/>	 --%>
<!--        </nav> -->
     </header>
     <!--content-->
     <div id="global">
       <div class="container-fluid">
         <div class="text-center dora-form-title"> 
	         <ww:if test="form.prepage.equals(\"3\")">
				売上（請負）承認画面
				<ww:include value="'/loginName.jsp'"/>	
		     </ww:if>
		     <ww:else>
		     	売上（請負）照会画面 	     
		     </ww:else>        
         </div>
         <div class="panel panel-default">
           <div class="panel-body">
<!--            	<div class="form-group" style="margin-top: 1rem;"> -->
<!--             	形式チェックエラーメッセージ -->
<%-- 				<ww:if test="hasFieldErrors()"> --%>
<%-- 					<ww:iterator value="fieldErrors"> --%>
<%-- 						<ww:iterator value="value" status="msg"> --%>
<%-- 							<ww:property /> --%>
<!-- 							<br> -->
<%-- 						</ww:iterator> --%>
<%-- 					</ww:iterator> --%>
<%-- 				</ww:if> --%>
<!-- 				業務チェックエラーメッセージ -->
<%-- 				<ww:if test="hasActionErrors()"> --%>
<%-- 					<ww:iterator value="actionErrors"> --%>
<%-- 						<ww:property /> --%>
<!-- 						<br> -->
<%-- 					</ww:iterator> --%>
<%-- 				</ww:if> --%>
<!-- 				正常なメッセージ -->
<%-- 				<ww:if test="form.getMsg() != null && form.getMsg().length() > 0"> --%>
<%-- 					<ww:property value="form.msg" /> --%>
<%-- 				</ww:if> --%>
<!--                </div> -->
             
               <!--button-->              
               <div class="form-group">
                 <div>                   			
					<ww:if test="form.prepage.equals(\"3\")">
						<input type="button" class="btn btn-primary dora-sm-button" value="戻る" onclick="submitFunction(this.form,'returnTopAction.action')">
					</ww:if>
					<ww:elseif test="form.prepage.equals(\"4\")">
						<input type="button" class="btn btn-primary dora-sm-button" value="戻る" onclick="hrefHaveParamAction('refreshSeikyuusyoriInfoInternal.action?form.print_sales_no=<ww:property value='form.print_sales_no'/>')">
					</ww:elseif>
					<ww:elseif test="form.prepage.equals(\"5\")">
					    <input type="button" class="btn btn-primary dora-sm-button" value="戻る" onclick="hrefAction('returnToSalesBunsekiSuii.action')">
					</ww:elseif>
					<ww:elseif test="form.prepage.equals(\"6\")">
					    <input type="button" class="btn btn-primary dora-sm-button" value="戻る" onclick="hrefAction('showUriageYoteiItiran.action')">
					</ww:elseif>
					<!-- sxt 20220825 add start -->
					<ww:elseif test="form.prepage.equals(\"7\")">
						<input type="button" class="btn btn-primary dora-sm-button" value="戻る" onclick="hrefAction('returnProjectDetail.action')">
					</ww:elseif>
					<!-- sxt 20220825 add end -->
					<ww:else>
						<input type="button" class="btn btn-primary dora-sm-button" value="戻る" onclick="submitFunction(this.form,'refreshNewUriage.action')">
					</ww:else>					
					<ww:if test="form.prepage.equals(\"3\")">
<!-- 						<input type="button" class="btn btn-primary dora-sm-button" value="保存" onclick="formSubmitDblClkChk(this.form,'uriageUpdateApprove.action');"> -->
						<input type="button" class="btn btn-primary dora-sm-button" value="承認" onclick="saveData(this.form,'ok')" />
						<input type="button" class="btn btn-primary dora-sm-button" value="却下" onclick="saveData(this.form,'ng')" />
					</ww:if>
                 </div>
               </div>

               <!--状態区域-->
               <div class="panel-body" style="padding:1.75rem 1rem">
	             <ww:if test="form.prepage.equals(\"3\")">
				 </ww:if>
				 <ww:else>
					<div class="dora-state-zone">承認(<ww:property value="form.approval_div"/>)	</div>						
				 </ww:else>					
                 <div class="dora-state-zone">契約形態 <ww:property value="form.contract_form_name" /></div>
                 <div class="dora-state-zone">請求区分 <ww:property value="form.order_div" /></div>
                 <div class="dora-state-zone">請求書発行(<ww:property value="form.request_flg"/>)</div>
                 <div class="dora-state-zone">入金(<ww:property value="form.sales_receipt_flg"/>)</div>
                 <div class="dora-state-zone">月次締(<ww:property value="form.month_close_flg"/>)</div>
                 
                 <div class="dora-state-zone form-inline">
                 	<label class="dora-label-right">売上担当者</label>
                    <ww:property value="form.sales_in_name_input"/>
                 </div>
                                          
               </div>

               <!--参照区域-->
               <div>
                 <ul id="myTab" class="nav nav-tabs" role="tablist">
                   <li role="presentation" class="active"><a href="#home" id="home-tab" role="tab" data-toggle="tab" aria-controls="home" aria-expanded="true">受注参照</a></li>
                 </ul>

                 <div class="panel panel-default">
                   <div id="myTabContent" class="tab-content">
                     <div role="tabpanel" class="tab-pane fade active in panel-body" id="home" aria-labelledby="home-tab">
                       <div class="form-group form-inline">
                         <span>
                           見積番号
                           <button type="button" class="btn btn-link" onclick="hrefHaveParamAction('mitumoriInfo.action?form.estimate_no=<ww:property value="form.estimate_no" />&form.pageFlg=7')">
                         		<ww:property value="form.estimate_no" />
                         	</button>	
                         </span>
                         <span>
                           受注番号
                           <button type="button" class="btn btn-link" onclick="hrefHaveParamAction('jyutyuInfo.action?form.pageFlg=4&form.receive_no=<ww:property value="form.received_no_input" />');">
                         		<ww:property value="form.received_no_input" />
                         	</button>
                         </span>
                         <span>
                           プロジェクトNo　<ww:property value="form.project_no" />　　
                         </span>

                         <span>
                           得意先　<ww:property value="form.customer_code_input" /> <ww:property value="form.customer_name_input" />
            				<ww:hidden name="'form.customer_code_input'" value="form.customer_code_input"></ww:hidden>
            				<ww:hidden name="'form.processing'" value="form.processing"></ww:hidden>
                         </span>
                       </div>
                     </div>
                   </div>
                 </div>               
               </div>

               <!--ヘッダー-->
               <div>
                 <ul id="myTab" class="nav nav-tabs" role="tablist">
                   <li role="presentation" class="active"><a href="#header" id="header-tab" role="tab" data-toggle="tab" aria-controls="header" aria-expanded="true">売上ヘッダー</a></li>                     
                 </ul>
                 <div class="panel panel-default">
                   <div id="myTabContent" class="tab-content">
                     <div role="tabpanel" class="tab-pane fade active in panel-body" id="header" aria-labelledby="header-tab">
                       <div class="form-group form-inline">
                         <label class="dora-label-left">件名</label>
                         <ww:property value="form.receive_name1"/>
                         <ww:property value="form.receive_name2"/>
                       </div>

                       <div class="form-group form-inline">
                         <label class="dora-label-left">売上番号</label>
                         <ww:property value="form.sales_no"/>

                         <label class="dora-label-right">売上日付</label>
                         <ww:property value="form.sales_date_input"/>
                       </div>

                       <div class="form-group form-inline">
                         <label class="dora-label-left">請求日付</label>
                         <ww:property value="form.request_date"/>
                         <label class="dora-label-right">入金予定日</label>
                         <ww:property value="form.input_pre_date"/>
                       </div>

                       <div class="form-group form-inline">
                         <label class="dora-label-left">作業期間</label>
                         <ww:property value="form.work_start_date"/>
                         <label>～</label>
                         <ww:property value="form.work_end_date"/>     
                       </div>

                       <div class="form-group form-inline">
                         <label class="dora-label-left" for="form.code_div_id">納品状況</label>
                         <ww:property value="form.delivery_status"/>
       
                         <label class="dora-label-right" for="form.code_div_id">消費税率(%)</label>
                         <ww:property value="form.tax_rates"/>
                         
                       </div>

                     </div>
                   </div>
                 </div>
               </div>

               <!--明細-->
               <div>
                 <ul id="myTab" class="nav nav-tabs" role="tablist">
                   <li role="presentation" class="active"><a href="#detail" id="detail-tab" role="tab" data-toggle="tab" aria-controls="detail" aria-expanded="true">売上明細</a></li>
                 </ul>

                 <div class="panel panel-default">
                   <div id="myTabContent" class="tab-content">
                     <div role="tabpanel" class="tab-pane fade active in panel-body" id="detail" aria-labelledby="detail-tab">
                       <table class="table table-bordered">
                         <thead>
                           <tr>
                             <td class="text-center" rowspan="2" style="width:4.5rem;">行</td>
                             <td class="text-center" rowspan="2" style="width:20rem;">作業内容</td>
                             <td class="text-center" rowspan="2" style="width:18rem;">単価</td>
                             <td class="text-center" rowspan="2" style="width:14rem;">数量</td>
                             <td class="text-center" style="width:17rem;">単位</td>
                             <td class="text-center" style="width:18rem;">金額</td>
                           </tr>
                           <tr>
                             <td class="text-center" nowrap>税区分</td>
                             <td class="text-center" nowrap>原価</td>
                             <ww:hidden name="'detailsize'" id="detailsize" value="form.salesDetailList.size()"></ww:hidden>
                           </tr>
                         </thead>
                         <tbody id="tbAddPart">
                           <%int s = 0; %>
                           <ww:iterator value="form.salesDetailList" status="rows" id="model">	
                           <% String trClass = ""; %>
						   <ww:if test="#rows.odd == true">
						   	 <% trClass = "success"; %>
						   </ww:if>
                           <tr class="<%=trClass%>">
                             <td class="text-center" rowspan="2" style="vertical-align:top;">
                               <ww:property value="row_number" />
                             </td>
                             <td rowspan="2" style="word-break:break-all">
                               <ww:property value="task_content"/>
                             </td>
                             <td class="text-right"  >
                               <!-- <ww:property value="price_per"/> -->	<!-- sxt 20221227 del -->
                               <!-- sxt 20221227 add start -->
                               <ww:if test="price_per.equals(\"\")">
									&nbsp;
								</ww:if>
								<ww:else>
									<ww:property value="price_per" />
								</ww:else>
								<!-- sxt 20221227 add end -->
                             </td>
                             <td class="text-right" >
                               <ww:property value="quantity"/> 
                             </td>
                             <td class="text-center" >
                               <ww:property value="unit_div"/>
                             </td>
                             <td class="text-right"  >
                               <ww:property value="amount"/>
                             </td>
                           </tr>
                           <tr class="<%=trClass%>">
                             <td class="text-center" ></td>
                             <td class="text-center" ></td>
                             <td class="text-center" >
                               <ww:if test="tax_div.equals('') || tax_div == null">
									&nbsp;
								</ww:if>
								<ww:else>
									<ww:property value="tax_div" />
								</ww:else>	
                             </td>
                             <td class="text-center" >
                               <ww:property value="org_price"/>
                               
                               	<ww:hidden name="'reg_id'" value="reg_id"></ww:hidden>
								<ww:hidden name="'reg_name'" value="reg_name"></ww:hidden>
								<ww:hidden name="'reg_date'" value="reg_date"></ww:hidden>
                             </td>
                           </tr>
                           
                           <%  s++; %>
						</ww:iterator>
                         </tbody>
                         
                         <tfoot>
							<tr class="info">
								<td colspan="2" nowrap rowspan="6"></td>
								<td class="text-center" nowrap colspan="3">合 計</td>
								<td class="text-right" nowrap><ww:property value="form.receive_amount"/></td>
							</tr>
							<tr class="info">
								<td class="text-center" nowrap colspan="3">消 費 税</td>
								<td class="text-right" nowrap><ww:property value="form.tax_amount"/></td>
							</tr>
							<tr class="info">
								<td class="text-center" nowrap colspan="3">税込合計</td>
								<td class="text-right" nowrap><ww:property value="form.tax_in_amount"/></td>
							</tr>
                       </tfoot>
                       </table>
                     </div>
                   </div>
                 </div>  
               </div>

               <!---->
               <div class="row" style="margin:1rem 0 0 0.25rem">
                 <div>
                   <label>
                   <ww:if test="form.prepage.equals(\"3\")">
						備考
					</ww:if>
					<ww:else>
						備考（最大長度１２５０漢字）
					</ww:else>
                   </label>
                   <textarea name="form.remark" class="form-control" rows="5" placeholder="備考" readonly><ww:property value='form.remark'/></textarea>
                 </div>
               </div>

               <div class="form-group"  style="margin-top:1.25rem">
                 <div>                   			
					<ww:if test="form.prepage.equals(\"3\")">
						<input type="button" class="btn btn-primary dora-sm-button" value="戻る" onclick="submitFunction(this.form,'returnTopAction.action')">
					</ww:if>
					<ww:elseif test="form.prepage.equals(\"4\")">
						<input type="button" class="btn btn-primary dora-sm-button" value="戻る" onclick="hrefHaveParamAction('refreshSeikyuusyoriInfoInternal.action?form.print_sales_no=<ww:property value='form.print_sales_no'/>')">
					</ww:elseif>
					<ww:elseif test="form.prepage.equals(\"5\")">
					    <input type="button" class="btn btn-primary dora-sm-button" value="戻る" onclick="hrefAction('returnToSalesBunsekiSuii.action')">
					</ww:elseif>
					<ww:elseif test="form.prepage.equals(\"6\")">
					    <input type="button" class="btn btn-primary dora-sm-button" value="戻る" onclick="hrefAction('showUriageYoteiItiran.action')">
					</ww:elseif>
					<!-- sxt 20220825 add start -->
					<ww:elseif test="form.prepage.equals(\"7\")">
						<input type="button" class="btn btn-primary dora-sm-button" value="戻る" onclick="hrefAction('returnProjectDetail.action')">
					</ww:elseif>
					<!-- sxt 20220825 add end -->
					<ww:else>
						<input type="button" class="btn btn-primary dora-sm-button" value="戻る" onclick="submitFunction(this.form,'refreshNewUriage.action')">
					</ww:else>					
					<ww:if test="form.prepage.equals(\"3\")">
<!-- 						<input type="button" class="btn btn-primary dora-sm-button" value="保存" onclick="formSubmitDblClkChk(this.form,'uriageUpdateApprove.action');"> -->
						<input type="button" class="btn btn-primary dora-sm-button" value="承認" onclick="saveData(this.form,'ok')" />
						<input type="button" class="btn btn-primary dora-sm-button" value="却下" onclick="saveData(this.form,'ng')" />
					</ww:if>
                 </div>
               </div>
           </div>
         </div>
       </div>
      		<ww:hidden name="'form.received_in_code_input'" value="form.received_in_code_input"></ww:hidden>
			<ww:hidden name="'form.sales_in_code_input'" value="form.sales_in_code_input"></ww:hidden>
			<ww:hidden name="'form.request_no'" value="form.request_no"></ww:hidden>
			<ww:hidden name="'form.request_date'" value="form.request_date"></ww:hidden>
			<ww:hidden name="'form.reg_id'" value="form.reg_id"></ww:hidden>
			<ww:hidden name="'form.reg_date'" value="form.reg_date"></ww:hidden>
			<ww:hidden name="'form.reg_name'" value="form.reg_name"></ww:hidden>
			<ww:hidden name="'form.approval_div'" value="form.approval_div"></ww:hidden>
       <ww:include value="'/footer.jsp'" />
     </div>
</form>
</body>
<ww:include value="'/footerJs.jsp'" />
<script language="JavaScript">
function saveData(pForm,kbn){
	if (kbn=="ok"){	
		//承認"
		$("input[name='form.approval_div'").val("03");
		
	} else if (kbn=="ng"){
		//却下
		$("input[name='form.approval_div'").val("02");
	}
	
	pForm.action = "uriageUpdateApprove.action";
	pForm.submit();	
}
</script>
</html>