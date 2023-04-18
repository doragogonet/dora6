<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="ww" uri="webwork" %>

<html lang="ja">
<head>
<ww:include value="'/headContent.jsp'" />
<title>
	<ww:if test="form.pageId.equals(\"6\")">
	仕入（常駐）承認画面
	</ww:if>
	<ww:else>
	仕入（常駐）照会画面
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
<script language="JavaScript">
	function submitAction(pForm,action){
		pForm.action = action;
		pForm.submit();	
	}
</script>			
</head>
<body class="cm-no-transition cm-1-navbar">

<form name="SiireForm" method="POST" class="form-horizontal">
  <header id="cm-header">
<!--       <nav class="cm-navbar cm-navbar-primary"> -->
<!--         <div class="cm-flex"> -->
<!--           <h1>日次処理 -->
<!--             <i class="fa fa-fw fa-angle-double-right"></i>  -->
<!--           </h1> -->
<!--         </div> -->
<%--         <ww:include value="'/header.jsp'"/>	 --%>
<!--       </nav> -->
    </header>
     
    <!--content-->
    <div id="global">
      <div class="container-fluid">
        <div class="text-center dora-form-title">
          	<ww:if test="form.pageId.equals(\"6\")">
			仕入（常駐）承認画面
			</ww:if>
			<ww:else>
			仕入（常駐）照会画面
			</ww:else>
          <ww:include value="'/loginName.jsp'"/>     
        </div>
        <div class="panel panel-default">
          <div class="panel-body">    
<!--             <div class="form-group" style="margin-top: 1rem;"> -->
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
<!--               </div> -->
              
              <!--button-->              
              <div class="form-group">
                <div>	
                	<ww:if test="form.pageId.equals(\"1\")">
						<input type="button" class="btn btn-primary dora-sm-button" value="戻る" onclick="submitAction(this.form,'refreshSiire.action');">
					</ww:if>
					<ww:if test="form.pageId.equals(\"2\")">
						<input type="button" class="btn btn-primary dora-sm-button" value="戻る" onclick="submitAction(this.form,'returnToSiireSuiiInternal.action');">
					</ww:if>
					<ww:if test="form.pageId.equals(\"3\")">
						<input type="button" class="btn btn-primary dora-sm-button" value="戻る" onclick="submitAction(this.form,'refreshSaveTop.action');">
					</ww:if>
					<ww:if test="form.pageId.equals(\"4\")">
						<input type="button" class="btn btn-primary dora-sm-button" value="戻る" onclick="submitAction(this.form,'showSiireYoteiItiran.action');">
					</ww:if>	
					<!-- sxt 20220826 add start -->
					<ww:if test="form.pageId.equals(\"5\")">
						<input type="button" class="btn btn-primary dora-sm-button" value="戻る" onclick="submitAction(this.form,'returnProjectDetail.action');">
					</ww:if>
					<!-- sxt 20220826 add end -->
					<!-- sxt 20220907 add start -->
					<ww:if test="form.pageId.equals(\"6\")">
						<input type="button" class="btn btn-primary dora-sm-button" value="戻る" onclick="submitAction(this.form,'returnTopAction.action');">
						<input type="button" class="btn btn-primary dora-sm-button" value="承認" onclick="saveData(this.form,'ok')" />
						<input type="button" class="btn btn-primary dora-sm-button" value="却下" onclick="saveData(this.form,'ng')" />
					</ww:if>
					<!-- sxt 20220907 add end -->
                </div>
              </div>
              
              <!--状態区域-->
                <div class="panel-body" style="padding:1.75rem 1rem">
                  <div class="dora-state-zone">月次締(<ww:property value="form.month_close_Name_itiran" />)</div>
                  <div class="dora-state-zone">支払(<ww:property value="form.stock_payment_Name_itiran" />)</div>
                  
                  <div class="dora-state-zone form-inline">
                  	<label class="dora-label-right">仕入担当者</label>
                    <ww:property value="form.stock_in_name_itiran" />
                  </div>
                                          
                </div>

              <!--参照区域-->
              <div style="padding-top:1rem;">
                <ul id="myTab" class="nav nav-tabs" role="tablist">
                  <li role="presentation" class="active"><a href="#home" id="home-tab" role="tab" data-toggle="tab" aria-controls="home" aria-expanded="true">発注参照</a></li>
                </ul>

                <div class="panel panel-default">
                  <div id="myTabContent" class="tab-content">
                    <div role="tabpanel" class="tab-pane fade active in panel-body" id="home" aria-labelledby="home-tab">
                      <div class="form-group form-inline">
                        <label class="dora-label-left">発注番号</label>
                        <label class="dora-label-normal btn-link" onclick="linkAction('showHattyuItiran2.action?form.order_no_itiran=<ww:property  value="form.order_no_itiran" />&form.page_flg=8','');"><ww:property  value="form.order_no_itiran" /></label>
                        <label class="dora-label-right">発注日付</label>
                        <label class="dora-label-normal"><ww:property value="form.order_date_itiran" /></label>
                      </div>

                      <div class="form-group form-inline">
                        <label class="dora-label-left">得意先</label>
                        <label class="dora-label-normal"><ww:property  value="form.customer_code_itiran" />　<ww:property value="form.customer_name_itiran" /></label>	
                      </div>

                      <div class="form-group form-inline">
                        <label class="dora-label-left">件名 </label>
                        <label class="dora-label-normal"><ww:property  value="form.stock_name1_hachu" />　<ww:property  value="form.stock_name2_hachu" /></label>
                      </div>

                      <div class="form-group form-inline">
                        <label class="dora-label-left">外注先 </label>
                        <label class="dora-label-normal"><ww:property value="form.out_order_code_itiran" />　<ww:property value="form.out_order_name_itiran" /></label>
                      </div>

                    </div>
                  </div>
                </div>               
              </div>

              <!--ヘッダー-->
              <div>
                <ul id="myTab" class="nav nav-tabs" role="tablist">
                  <li role="presentation" class="active"><a href="#header" id="header-tab" role="tab" data-toggle="tab" aria-controls="header" aria-expanded="true">仕入ヘッダー</a></li>                     
                </ul>
                <div class="panel panel-default">
                  <div id="myTabContent" class="tab-content">
                    <div role="tabpanel" class="tab-pane fade active in panel-body" id="header" aria-labelledby="header-tab">
                      <div class="form-group form-inline">
                        <label class="dora-label-left">仕入番号</label>
                        <ww:property value="form.stock_no_itiran" />
                        <label class="dora-label-right">仕入日付</label>
                        <ww:property value="form.stock_date_itiran" />
                        <label class="dora-label-right">外注請求番号</label>
                        <ww:property value="form.out_order_no_itiran" />
                      </div>
                      
                      <div class="form-group form-inline">
                        <label class="dora-label-left">件名</label>
                        <ww:property value="form.stock_name1_itiran" />　<ww:property value="form.stock_name2_itiran" />
                      </div>

                      <div class="form-group form-inline">
                        <label class="dora-label-left">作業期間</label>
                        <ww:property value="form.work_start_date_itiran" />
                        <label>～</label>  
                        <ww:property value="form.work_end_date_itiran" />
                       
                      </div>

                      <div class="form-group form-inline">
                        <label class="dora-label-left">納品状況</label>
						<ww:property value="form.delivery_status_itiran" />

                        <label class="dora-label-right">支払予定日</label>
                        <ww:property value="form.payment_date_itiran" />
                        <label class="dora-label-right">消費税率(%)</label>
                        <ww:property value="form.consume_tax_rate_itiran" />
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
											<!-- sxt 20221031 del start -->
<!-- 											<td colspan="2" -->
<!-- 											style="width: 15rem;vertical-align:middle;">　</td> -->
											<!-- sxt 20221031 del end -->
											<!-- sxt 20221031 add start -->
											<td class="text-center"
												style="width: 15rem;vertical-align:middle;">精算単位
											</td>
											<td>
												<input type="text" class="form-control" value="<ww:property value='form.time_unit'/>"
													style="background-color:#fff" readonly>
											</td>
											<!-- sxt 20221031 add end -->
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
												<input type="text" id="work_time_from1" class="form-control text-right" value="<ww:property value='form.work_time_from'/>"
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
                  <li role="presentation" class="active"><a href="#detail" id="detail-tab" role="tab" data-toggle="tab" aria-controls="detail" aria-expanded="true">仕入明細</a></li>
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
							<!-- sxt 20221003 add start -->
							<td class="text-center" style="width:15rem;" rowspan="2">超過単価（円）</td>
							<td class="text-center" style="width:15rem;" rowspan="2">控除単価（円）</td>
							<!-- sxt 20221003 add end -->
							<td class="text-center" style="width:15rem;" rowspan="2">精算額（円）</td>
<!-- 							<td class="text-center" style="width:10rem;" rowspan="2">そのた（円）</td> -->	<!-- sxt 20221024 del -->
							<td class="text-center" style="width:15rem;" rowspan="2">金額（円）</td>
							<td class="text-center" style="width:15rem;" rowspan="2">旅費（円）</td>
							<td class="text-center" style="width:45rem;" rowspan="2">備考</td>
                          </tr>
                        </thead>
                        <tbody id="tbAddPart">
                          <%int temp = 0 ;%>
						  <ww:iterator value="form.stockDetailModelList_itiran" status="rows" id="model">
						    <% String trClass = ""; %>
						    <ww:if test="#rows.odd == true">
						   	  <% trClass = "success"; %>
						    </ww:if>
							<tr class="<%=trClass%>">
	                            <td class="text-center" rowspan="2">
	                              <ww:property value="row_number" />
	                            </td>
	                            <td style="word-break:break-all">
	                              <ww:property value="task_content" />
	                            </td>
	                            <td class="text-center" rowspan="2">
	                              <ww:property value="time_kbn" />
	                            </td>
	                            <td class="text-right" rowspan="2">
		                            <ww:property value="price_per" />
	                            </td>
	                            <td class="text-right" rowspan="2">
	                              <ww:property value="quantity" />
	                            </td>
	                            <!-- sxt 20221003 add start -->
	                            <td class="text-right" rowspan="2">
	                              <ww:property value="more_price" />
	                            </td>
	                            <td class="text-right" rowspan="2">
	                              <ww:property value="less_price" />
	                            </td>
	                            <!-- sxt 20221003 add end -->
	                            <td class="text-right" rowspan="2">
	                              <ww:property value="calculate_amount" />
	                            </td>
	                            <!-- sxt 20221024 del start -->
<!-- 	                            <td class="text-right" rowspan="2"> -->
<%-- 	                              <ww:property value="other_price" /> --%>
<!-- 	                            </td> -->
	                            <!-- sxt 20221024 del end -->
	                            <td class="text-right" rowspan="2">
	                              <ww:property value="amount" />
	                            </td>
	                            <td class="text-right" rowspan="2">
	                              <ww:property value="carfare" />
	                            </td>
	                            <td rowspan="2">
		                            <ww:property value="biko" />
	                            </td>
	                          </tr>
	                          <tr class="<%=trClass%>">
	                            <td>
	                             	<ww:if test="company_name.equals('') || company_name == null">
										&nbsp;
									</ww:if>
									<ww:else>
										<ww:property value="company_name" />
									</ww:else>
	                            </td>
	                        </tr>
                          <%  temp ++; %>
						  </ww:iterator>
                        </tbody>
                        <tfoot>
                          <tr class="info">
                            <td colspan="6" rowspan="4"></td>
                            <td class="text-center" colspan="2">課税対象額計</td>
                            <td class="text-right"><ww:property value="form.stock_quantity_sum_itiran" /></td>
                          </tr>
                          <tr class="info">
                            <td class="text-center" nowrap colspan="2">消費税</td>
                            <td class="text-right"><ww:property value="form.stock_consume_tax_sum_itiran" /></td>
                          </tr>
                          <tr class="info">
							<td class="text-center" nowrap colspan="2">交通費など</td>
							<td class="text-right" nowrap>
								<ww:property value='form.carfare'/>
							</td>
						  </tr>
                          <tr class="info">
                            <td class="text-center" nowrap colspan="2">合計額</td>
                            <td class="text-right"><ww:property value="form.stock_quantity_tax_sum_itiran" /></td>
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
                  <label for="state">備考（最大長度１２５０漢字）</label>
                  <textarea name="form.remark" class="form-control" rows="5" placeholder="備考" readonly><ww:property value='form.remark'/></textarea>
                </div>
              </div>
  
              <div class="form-group"  style="margin-top:1.25rem">
				<div>	
                	<ww:if test="form.pageId.equals(\"1\")">
						<input type="button" class="btn btn-primary dora-sm-button" value="戻る" onclick="submitAction(this.form,'refreshSiire.action');">
					</ww:if>
					<ww:if test="form.pageId.equals(\"2\")">
						<input type="button" class="btn btn-primary dora-sm-button" value="戻る" onclick="submitAction(this.form,'returnToSiireSuiiInternal.action');">
					</ww:if>
					<ww:if test="form.pageId.equals(\"3\")">
						<input type="button" class="btn btn-primary dora-sm-button" value="戻る" onclick="submitAction(this.form,'refreshSaveTop.action');">
					</ww:if>
					<ww:if test="form.pageId.equals(\"4\")">
						<input type="button" class="btn btn-primary dora-sm-button" value="戻る" onclick="submitAction(this.form,'showSiireYoteiItiran.action');">
					</ww:if>	
					<!-- sxt 20220826 add start -->
					<ww:if test="form.pageId.equals(\"5\")">
						<input type="button" class="btn btn-primary dora-sm-button" value="戻る" onclick="submitAction(this.form,'returnProjectDetail.action');">
					</ww:if>
					<!-- sxt 20220826 add end -->
					<!-- sxt 20220907 add start -->
					<ww:if test="form.pageId.equals(\"6\")">
						<input type="button" class="btn btn-primary dora-sm-button" value="戻る" onclick="submitAction(this.form,'returnTopAction.action');">
						<input type="button" class="btn btn-primary dora-sm-button" value="承認" onclick="saveData(this.form,'ok')" />
						<input type="button" class="btn btn-primary dora-sm-button" value="却下" onclick="saveData(this.form,'ng')" />
					</ww:if>
					<!-- sxt 20220907 add end -->
                </div>
              </div>
          </div>
        </div>
      </div>
      <ww:include value="'/footer.jsp'" />
      <ww:hidden name="'form.approval_div_input_itiran'" value="form.approval_div_input_itiran"></ww:hidden>
      <ww:hidden name="'form.payment_method'" > </ww:hidden><!-- sxt 20220923 add -->
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
		$("input[name='form.approval_div_input_itiran'").val("03");
		
	} else if (kbn=="ng"){
		//却下
		$("input[name='form.approval_div_input_itiran'").val("02");
	}
	
	pForm.action = "saveSiireSixyounin.action";
	pForm.submit();	
}
</script>
</html>
			