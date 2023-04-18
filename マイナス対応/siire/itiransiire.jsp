<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="ww" uri="webwork" %>

<html lang="ja">
<head>
<ww:include value="'/headContent.jsp'" />
<title>
	<ww:if test="form.pageId.equals(\"6\")">
	仕入（請負）承認画面
	</ww:if>
	<ww:else>
	仕入（請負）照会画面
	</ww:else>
</title>
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
			仕入（請負）承認画面
			</ww:if>
			<ww:else>
			仕入（請負）照会画面
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
                        <label class="dora-label-normal btn-link" onclick="linkAction('showHattyuItiran.action?form.order_no_itiran=<ww:property  value="form.order_no_itiran" />&form.page_flg=8','');"><ww:property  value="form.order_no_itiran" /></label>
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
                            <td class="text-center" rowspan="2" style="width:4.5rem;">行</td>
                            <td class="text-center" rowspan="2" style="width:40rem;">作業内容</td>
                            <td class="text-center" rowspan="2" style="width:18rem;">単価</td>
                            <td class="text-center" rowspan="2" style="width:14rem;">数量</td>
                            <td class="text-center" style="width:16rem;">単位</td>
                            <td class="text-center" rowspan="2" style="width:18rem;">金額</td>
                          </tr>
                          <tr>
                            <td class="text-center" nowrap>税区分</td>
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
	                            <td rowspan="2" style="word-break:break-all">
	                              <ww:property value="task_content" />
	                            </td>
	                            <td class="text-right">
		                            <ww:property value="price_per" />
	                            </td>
	                            <td class="text-right" >
	                              <ww:property value="quantity" />
	                            </td>
	                            <td class="text-center">
		                            <ww:property value="unit_name" />
	                            </td>
	                            <td class="text-right">
		                            <ww:if test="amount.length() == 0">
										&nbsp;
									</ww:if>
									<ww:else>
										<ww:property value="amount" />
									</ww:else>	
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
	                            <td class="text-center" ></td>
	                        </tr>
                          <%  temp ++; %>
						  </ww:iterator>
                        </tbody>
                        <tfoot>
                          <tr class="info">
                            <td class="text-center" colspan="2"  rowspan="3"></td>
                            <td colspan="3">合 計</td>
                            <td class="text-right"><ww:property value="form.stock_quantity_sum_itiran" /></td>
                          </tr>
                          <tr class="info">
                            <td colspan="3">消費税</td>
                            <td class="text-right"><ww:property value="form.stock_consume_tax_sum_itiran" /></td>
                          </tr>
                          <tr class="info">
                            <td colspan="3">税込合計</td>
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
    </div>
    
</form>	
</body>
<ww:include value="'/footerJs.jsp'" />
<script language="JavaScript">
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
			