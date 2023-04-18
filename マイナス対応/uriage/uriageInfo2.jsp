<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="ww" uri="webwork" %>
<html lang="ja">
<head>
<ww:include value="'/headContent.jsp'" />
<title>
	<ww:if test="form.prepage.equals(\"3\")">
	売上（常駐）承認画面 			
   	</ww:if>
  	<ww:else>
  	売上（常駐）照会画面 	     
  	</ww:else> 
</title>
	<!-- sxt 20220923 add start -->
	<style>
		.flex{
			display: flex;
		}
		.flex-left{
			flex-basis: 36rem;
		}
		.flex-right{
			flex-basis: auto;
		}
	</style>
	<!-- sxt 20220923 add end -->
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
				売上（常駐）承認画面
				<ww:include value="'/loginName.jsp'"/>		
		     </ww:if>
		     <ww:else>
		     	売上（常駐）照会画面 	     
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
                       
                       <!-- sxt 20220923 add start -->
		                <div class="form-group flex" style="padding-top:1rem;">
							<div class="flex-left" style="padding-left:0.625rem;">
								<label for="estimate_date">精算方法</label>
								<ww:if test="form.payment_method.equals(\"1\")">
									<input type="checkbox" checked disabled>
								</ww:if>
								<ww:else>
									<input type="checkbox" disabled>
								</ww:else>
								<table class="table table-bordered" id="payment_method1">
									<tr>
										<td colspan="3" class="text-center">月間作業基準時間（H）</td>
									</tr>
									<tr>
										<td class=" text-right" style="border-right-width:0px;">
											<input type="text" class="form-control" value="<ww:property value='form.work_time_from'/>"
													style="width:6rem;display:inline;background-color:#fff" readonly>
													
										</td>
										<td class="text-center"
											style="vertical-align:middle;border-left-width: 0px;border-right-width:0px;">
											～</td>
										<td style="border-left-width:0px;">
											<input type="text" class="form-control text-right" value="<ww:property value='form.work_time_to'/>"
												style="width:6rem;display:inline;background-color:#fff" readonly>
										</td>
									</tr>
		
								</table>
							</div>
							<div class="flex-right" style="padding-left:2rem;">
								<label for="estimate_date">　</label>
								<table class="table table-bordered" id="payment_method2">
									<tbody>
										<tr>
											<td class="text-center"
												style="width: 15rem;vertical-align:middle;">精算単位
											</td>
											<td>
											
											<input type="text" class="form-control" value="<ww:property value='form.time_unit'/>"
												style="background-color:#fff" readonly>
											</td>
										</tr>
										<tr>
											<td class="text-center" style="border-bottom:0;">
												<div class="checkbox">
													<label>
														超過時間精算：
													</label>
												</div>
											</td>
											<td style="border-bottom:0;padding: 0.5rem 0.5rem 0 0.5rem;">
												<input type="text" id="work_time_to1" class="form-control text-right"  value="<ww:property value='form.work_time_to'/>" 
													style="height:1rem;width:6rem;display:inline;background-color:#fff" readonly>
												時間を超えた時間数を超過時間とする。
											</td>
										</tr>
										<tr>
											<td style="border-top:0;border-bottom:0;"></td>
											<td style="border:0;padding: 0 0.5rem 0.75rem 0.5rem;">
												超過単価：月額単価<span
													style="font:1rem Verdana,Arial,Tahoma;"> ÷ </span>
												<input type="text" id="work_time_to2" class="form-control text-right"  value="<ww:property value='form.work_time_to'/>" 
													style="height:1rem;width:6rem;display:inline;background-color:#fff" readonly>
												時間
											</td>
										</tr>
										<tr>
											<td style="border-top:0;border-bottom:0;"></td>
											<td style="border:0;padding: 0 0.5rem 0.5rem 0.5rem;">
												精算方式：超過単価<span
													style="font:1rem Verdana,Arial,Tahoma;"> ×
												</span>超過時間
											</td>
										</tr>
										
										<tr>
											<td class="text-center" style="border-bottom:0;">
												<div class="checkbox">
													<label>
														控除時間精算：
													</label>
												</div>
											</td>
											<td style="border-bottom:0;padding: 0.5rem 0.5rem 0 0.5rem;">
												<input type="text" id="work_time_from1" class="form-control text-righ" value="<ww:property value='form.work_time_from'/>"
													style="height:1rem;width:6rem;display:inline;background-color:#fff" readonly>
												時間に満たない時間数を控除時間とする。
											</td>
										</tr>
										<tr>
											<td style="border-top:0;border-bottom:0;"></td>
											<td style="border:0;padding: 0 0.5rem 0.75rem 0.5rem;">
												控除単価：月額単価<span
													style="font:1rem Verdana,Arial,Tahoma;"> ÷ </span>
												<input type="text" id="work_time_from2" class="form-control text-right" value="<ww:property value='form.work_time_from'/>"
													style="height:1rem;width:6rem;display:inline;background-color:#fff" readonly>
												時間
											</td>
										</tr>
										<tr>
											<td style="border-top:0;border-bottom:0;"></td>
											<td style="border:0;padding: 0 0.5rem 0.5rem 0.5rem;">
												精算方式：控除単価<span
													style="font:1rem Verdana,Arial,Tahoma;"> ×
												</span>控除時間
											</td>
										</tr>
										
									</tbody>
								</table>
							</div>
						</div>
		                <!-- sxt 20220923 add end -->

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
	                            <td class="text-center" style="width:4.5rem;" rowspan="2">行</td>
								<td class="text-center" style="width:40rem;" rowspan="2">内容</td>
								<td class="text-center" style="width:8rem;" rowspan="2"></td>
								<td class="text-center" style="width:15rem;" rowspan="2">単価（円）</td>
								<td class="text-center" style="width:15rem;" rowspan="2">稼働時間（H）</td>
								<td class="text-center" style="width:15rem;" rowspan="2">超過単価（円）</td>
								<td class="text-center" style="width:15rem;" rowspan="2">控除単価（円）</td>
								<td class="text-center" style="width:15rem;" rowspan="2">精算額（円）</td>
<!-- 								<td class="text-center" style="width:10rem;" rowspan="2">そのた（円）</td> -->	<!-- sxt 20221024 del -->
								<td class="text-center" style="width:15rem;" rowspan="2">金額（円）</td>
								<td class="text-center" style="width:15rem;" rowspan="2">旅費（円）</td>
								<td class="text-center" style="width:45rem;" rowspan="2">備考</td>
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
                             <td class="text-center" style="vertical-align:top;" rowspan="2">
                               <ww:property value="row_number" />
                             </td>
                             <td style="word-break:break-all">
                               <ww:property value="task_content"/>
                             </td>
                             <td class="text-center" rowspan="2">
                               <ww:property value="time_kbn"/>
                             </td>
                             <td class="text-right" rowspan="2">
                               <ww:property value="price_per"/> 
                             </td>
                             <td class="text-right" rowspan="2">
                               <ww:property value="quantity"/> 
                             </td>
                             <td class="text-right" rowspan="2">
                               <ww:property value="more_price"/>
                             </td>
                             <td class="text-right" rowspan="2">
                               <ww:property value="less_price"/>
                             </td>
                             <td class="text-right" rowspan="2">
                               <ww:property value="calculate_amount"/>
                             </td>
                             <!-- sxt 20221024 del start -->
<!--                              <td class="text-right" rowspan="2"> -->
<%--                                <ww:property value="other_price"/> --%>
<!--                              </td> -->
                             <!-- sxt 20221024 del end -->
                             <td class="text-right" rowspan="2">
                               <ww:property value="amount"/>
                             </td>
                             <td class="text-right" rowspan="2">
                               <ww:property value="carfare"/>
                             </td>
                             <td  style="word-break:break-all" rowspan="2">
                               <ww:property value="biko"/>
                             </td>
                           </tr>
                          	<tr class="<%=trClass%>">
                            	<td style="border-top: none;">
                            		<ww:if test="company_name.equals('') || company_name == null">
                            			&nbsp;
                            		</ww:if>
                            		<ww:else>
                            			<ww:property value="company_name"/>
                            		</ww:else>	
									
								</td>
                          	</tr>
                           <%  s++; %>
						</ww:iterator>
                         </tbody>
                         
                         <tfoot>
							<tr class="info">
								<td colspan="8" nowrap rowspan="4"></td>
								<td class="text-center" nowrap colspan="2">課税対象額計</td>
								<td class="text-right" nowrap><ww:property value="form.receive_amount"/></td>
							</tr>
							<tr class="info">
								<td class="text-center" nowrap colspan="2">消費税</td>
								<td class="text-right" nowrap><ww:property value="form.tax_amount"/></td>
							</tr>
							<tr class="info">
								<td class="text-center" nowrap colspan="2">交通費など</td>
								<td class="text-right" nowrap><ww:property value='form.carfare'/></td>
							</tr>
							<tr class="info">
								<td class="text-center" nowrap colspan="2">合計額</td>
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
			<ww:hidden name="'form.payment_method'" > </ww:hidden><!-- sxt 20220923 add -->
       <ww:include value="'/footer.jsp'" />
     </div>
</form>
</body>
<ww:include value="'/footerJs.jsp'" />
<script language="JavaScript">

//sxt 20220923 add start
$(document).ready(function(){
	/* 精算方法*/
	var payment_method = $("input[name='form.payment_method']").val();		
	if (payment_method == '1'){
		$("#payment_method1").show();
		$("#payment_method2").show();
	} else {
		$("#payment_method1").hide();
		$("#payment_method2").hide();
	}
});
//sxt 20220923 add end

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