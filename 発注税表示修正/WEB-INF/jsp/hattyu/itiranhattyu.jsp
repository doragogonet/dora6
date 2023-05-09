<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="ww" uri="webwork" %>
<html lang="ja">
	<head>
	<ww:include value="'/headContent.jsp'" />
	<title>
		<ww:if test="form.page_flg.equals(\"2\")">
		発注（請負）承認画面
		</ww:if>
		<ww:else>
		発注（請負）照会画面
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
<form name="HattyuForm" method="post" class="form-horizontal">
	<header id="cm-header">
<!-- 		<nav class="cm-navbar cm-navbar-primary"> -->
<!-- 			<div class="cm-flex"> -->
<!-- 				<h1> -->
<!-- 					日次処理 -->
<!-- 					<i class="fa fa-fw fa-angle-double-right"></i>					 -->
<!-- 				</h1> -->
<!-- 			</div> -->
<%-- 			<ww:include value="'/header.jsp'"/>	 --%>
<!-- 		</nav> -->
	</header>
	  <div id="global">
    <div class="container-fluid">
      <div class="text-center dora-form-title">
        <ww:if test="form.page_flg.equals(\"2\")">
		発注（請負）承認画面
		</ww:if>
		<ww:else>
		発注（請負）照会画面
		</ww:else>
        <ww:include value="'/loginName.jsp'"/>
      </div>
      <div class="panel panel-default">
        <div class="panel-body">
        
        	<ww:include value="'/message.jsp'" />

            <div class="form-group" style="margin-top:1rem;">
              <div>                  
                <ww:if test="form.page_flg.equals(\"6\")">
					<input type="button" class="btn btn-primary dora-sm-button" value="戻る" onclick="submitAction(this.form,'initialSiireSinki.action');">
				</ww:if>
				<ww:if test="form.page_flg.equals(\"7\")">
					<input type="button" class="btn btn-primary dora-sm-button" value="戻る" onclick="submitAction(this.form,'initialUpdateSiire.action');">
				</ww:if>
				<ww:if test="form.page_flg.equals(\"8\")">
					<input type="button" class="btn btn-primary dora-sm-button" value="戻る" onclick="submitAction(this.form,'showSiireItiran.action');">
				</ww:if>
				<ww:if test="form.page_flg.equals(\"9\")">
					<input type="button" class="btn btn-primary dora-sm-button" value="戻る" onclick="submitAction(this.form,'initialSiireSixyounin.action');">
				</ww:if>
				<ww:if test="form.page_flg.equals(\"10\")">
					<input type="button" class="btn btn-primary dora-sm-button" value="戻る" onclick="submitAction(this.form,'refreshHattyu.action');">
				</ww:if>
				<ww:if test="form.page_flg.equals(\"11\")">
					<input type="button" class="btn btn-primary dora-sm-button" value="戻る" onclick="submitAction(this.form,'refreshHattyu.action');">
				</ww:if>
				<ww:if test="form.page_flg.equals(\"12\")">
					<input type="button" class="btn btn-primary dora-sm-button" value="戻る" onclick="submitAction(this.form,'returnToShowDetailOneHattyu.action');">
				</ww:if>
				<ww:if test="form.page_flg.equals(\"13\")">
					<input type="button" class="btn btn-primary dora-sm-button" value="戻る" onclick="submitAction(this.form,'returnToRefreshAllHattyu.action');">
				</ww:if>
				<ww:if test="form.page_flg.equals(\"14\")">
					<input type="button" class="btn btn-primary dora-sm-button" value="戻る" onclick="submitAction(this.form,'refreshSaveTop.action');">
				</ww:if>
				<!-- sxt 20220718 add start -->
				<ww:if test="form.page_flg.equals(\"15\")">
					<input type="button" class="btn btn-primary dora-sm-button" value="戻る" onclick="submitAction(this.form,'showHattyuBunseki.action');">
				</ww:if>
				<!-- sxt 20220718 add end -->
				<!-- sxt 20220826 add start -->
				<ww:if test="form.page_flg.equals(\"16\")">
					<input type="button" class="btn btn-primary dora-sm-button" value="戻る" onclick="submitAction(this.form,'returnProjectDetail.action');">
				</ww:if>
				<!-- sxt 20220826 add end -->
				<!-- sxt 20220907 add start -->
				<ww:if test="form.page_flg.equals(\"2\")">
					<input type="button" class="btn btn-primary dora-sm-button" value="戻る" onclick="submitFunction(this.form,'returnTopAction.action')" />
					<input type="button" class="btn btn-primary dora-sm-button" value="承認" onclick="saveData(this.form,'ok')" />
					<input type="button" class="btn btn-primary dora-sm-button" value="却下" onclick="saveData(this.form,'ng')" />
				</ww:if>
				<!-- sxt 20220907 add end -->
              </div>
            </div>
            
            <!--状態区域-->
            <div class="panel-body" style="padding:1.75rem 1rem">
               <div class="dora-state-zone">契約形態(<ww:property value='form.contract_form_name'/>)</div>
               <%-- <div class="dora-state-zone">月次締(<ww:property value='form.month_close_Name_itiran'/>)</div> --%>	<!-- sxt 20230201 del -->
<%--                <div class="dora-state-zone">請求区分　<ww:property value='form.order_div_name_itiran'/></div> --%>	<!-- sxt 20221008 del -->
			   <div class="dora-state-zone">請求区分　<ww:property value='form.Order_div_name_itirantwo'/></div>			<!-- sxt 20221008 add -->
               
               <div class="dora-state-zone form-inline">
               	<label class="dora-label-right">発注担当者</label>
                   <ww:property value='form.order_in_name_itiran'/>
               </div>
            </div>
            
            <!--参照区域-->
            <div style="margin-top:1.75rem;">
              <ul id="myTab" class="nav nav-tabs" role="tablist">
                <li role="presentation" class="active"><a href="#home" id="home-tab" role="tab" data-toggle="tab"
                    aria-controls="home" aria-expanded="true">受注参照</a></li>
              </ul>
              <div class="panel panel-default">
                <div id="myTabContent" class="tab-content">
                  <div role="tabpanel" class="tab-pane fade active in panel-body" id="home" aria-labelledby="home-tab">
                    <div class="form-group form-inline">
                      <label class="dora-label-left">受注番号</label>
                      <!-- sxt 20221010 del start -->
<%--                       <label class="dora-label-normal btn-link" onclick="hrefHaveParamAction('jyutyuInfo.action?form.pageFlg=8&form.receive_no=<ww:property  value="form.receive_no_itiran" />')"> --%>
<%--                       	<ww:property value="form.receive_no_itiran" /> --%>
<!--                       </label> -->
                      <!-- sxt 20221010 del end -->
                      
                      <!-- sxt 20221010 add start -->
						<ww:if test="form.jyutyuShurui.equals(\"2\")">
	                        <label class="dora-label-normal btn-link" onclick="hrefHaveParamAction('jyutyuInfo.action?form.pageFlg=8&hattyuShurui=<ww:property value="form.shurui"/>&form.receive_no=<ww:property  value="form.receive_no_itiran" />')">
		                      	<ww:property value="form.receive_no_itiran" />
		                    </label>
						</ww:if>
						<ww:else>
	                        <label class="dora-label-normal btn-link" onclick="hrefHaveParamAction('jyutyuInfo2.action?form.pageFlg=8&hattyuShurui=<ww:property value="form.shurui"/>&form.receive_no=<ww:property  value="form.receive_no_itiran" />')">
		                      	<ww:property value="form.receive_no_itiran" />
		                    </label>
						</ww:else>
						<!-- sxt 20221010 add end -->
                    </div>
                    <div class="form-group form-inline">
                      <label class="dora-label-left">得意先</label>
                      <label class="dora-label-normal"> <ww:property  value="form.customer_code_itiran" />　<ww:property value="form.customer_name_itiran" /></label>
                    </div>
                    <div class="form-group form-inline">
                      <label class="dora-label-left">件名</label>
                      <label class="dora-label-normal"><ww:property value="form.receive_name1_itiran" />　<ww:property value="form.receive_name2_itiran" /></label>
                    </div>
                    <div class="form-group form-inline">
                      <label class="dora-label-left">作業期間</label>
                      <label class="dora-label-normal"><ww:property value="form.work_start_date_itiran" /> ～ <ww:property value="form.work_end_date_itiran" /></label>
                    </div>
                    
                    <div class="form-group form-inline">
                       <label class="dora-label-left">受注額 </label>
                       <label class="dora-label-normal">￥<ww:property value="form.receive_amount"/>円</label>
                       <label class="dora-label-right">発注残 </label>
                       <label class="dora-label-normal">￥<ww:property value="form.order_zan"/>円</label>
                     </div>
                  </div>
                  
                </div>
              </div>
            </div>
            
            <!--ヘッダー-->
            <div>
              <ul id="myTab" class="nav nav-tabs" role="tablist">
                <li role="presentation" class="active"><a href="#header" id="header-tab" role="tab" data-toggle="tab" aria-controls="header" aria-expanded="true">発注ヘッダー</a></li>                     
              </ul>
              <div class="panel panel-default">
                <div id="myTabContent" class="tab-content">
                  <div role="tabpanel" class="tab-pane fade active in panel-body" id="header" aria-labelledby="header-tab">
                    <div class="form-group form-inline">
                      <label class="dora-label-left">発注番号</label>
                      <ww:property value="form.order_no_itiran" />
                      <label class="dora-label-right">発注日付</label>
                      <ww:property value="form.order_date_itiran" />
                      
                      <label class="dora-label-right">発注担当者</label>
                      <ww:property value="form.order_in_name_itiran" />
                    </div>

                    <div class="form-group form-inline">
                      <label class="dora-label-left">外注先</label>
                      <ww:property value="form.out_order_code_itiran" />　<ww:property value="form.out_order_name_itiran"/>

                      <label class="dora-label-right">外注お見積番号 </label>
                      <ww:property value="form.out_estimate_no_itiran"/>
                    </div>

                    <div class="form-group form-inline">
                      <label class="dora-label-left">件名</label>
                      <ww:property value="form.order_name1_input_itiran" />　<ww:property value="form.order_name2_input_itiran" />
                    </div>
					
					<!-- sxt 20221008 del start -->
<!--                     <div class="form-group form-inline"> -->
<!--                       <label class="dora-label-left">契約形態</label> -->
<%--                       <ww:property value="form.contract_form_name"/> --%>

<!--                       <label class="dora-label-right">納品状態</label> -->
<%--                       <ww:property value="form.delivery_status_name"/> --%>

<!--                       <label class="dora-label-right">請求区分</label> -->
<%--                       <ww:property value="form.Order_div_name_itirantwo"/>     --%>
<!--                     </div> -->
                    <!-- sxt 20221008 del end -->

                    <div class="form-group form-inline">
                      <label class="dora-label-left">作業期間</label>
                      <ww:property value="form.work_start_date_itiran" /> ～ <ww:property value="form.work_end_date_itiran" />
                      <label class="dora-label-right">消費税率(%)</label>
					  <ww:property value='form.consume_tax_rate_itiran'/>
					  <!-- sxt 20221008 add start -->
					  <label class="dora-label-right">納品状態</label>
                      <ww:property value="form.delivery_status_name"/>
					  <!-- sxt 20221008 add end -->
                    </div>

                    <div class="form-group form-inline">
                      <label class=" dora-label-left">支払条件</label>
                      <label class="dora-label-normal">検収日</label>  
                      <ww:property value="form.payment_condition1_update" />

                      <label class="dora-label-normal" style=" padding-left:3rem;">支払日</label>  
                      <ww:property value="form.payment_condition2_update" />

                      <label class="dora-label-right">納品予定日</label>
                      <ww:property value="form.delivery_date_itiran" />
                    </div>
                  </div>
                </div>
              </div>        
            </div>
            
            <!--明細-->
            <div>
              <ul id="myTab" class="nav nav-tabs" role="tablist">
                <li role="presentation" class="active"><a href="#detail" id="detail-tab" role="tab" data-toggle="tab"
                    aria-controls="detail" aria-expanded="true">発注照会明細</a></li>
              </ul>
              <div class="panel panel-default">
                <div id="myTabContent" class="tab-content">
                  <div role="tabpanel" class="tab-pane fade active in panel-body" id="detail" aria-labelledby="detail-tab">
                    <table class="table table-bordered table-hover">
                      <thead>
                        <tr>
                          <td class="text-center" width="3%" nowrap rowspan="2">行</td>
                          <td class="text-center" nowrap rowspan="2" colspan="2">作業内容</td>
                          <td class="text-center" width="10%" nowrap rowspan="2">単価</td>
                          <td class="text-center" width="10%" nowrap rowspan="2">数量</td>
                          <td class="text-center" width="12%" nowrap>単位</td>
                          <td class="text-center" width="12%" rowspan="2">金額</td>
                        </tr>
                        <tr>
                          <td class="text-center" nowrap>税区分</td>
                        </tr>
                      </thead>
                      <tbody>
                      <ww:iterator value="form.stockDetailModelList_itiran" status="rows" >
                      	<% String trClass = ""; %>
						<ww:if test="#rows.odd == true">
							<% trClass = "success"; %>
						</ww:if>
							
						<tr class="<%=trClass%>">
							<td class="text-center" width="3%" nowrap rowspan="2"><ww:property value="row_number" /></td>
							<td nowrap rowspan="2" width="500" colspan="2"  style="word-break:break-all" ><ww:property value="task_content" /></td>
							<td class="text-right" width="10%" nowrap><ww:property value="price_per" /></td>
							<td class="text-right" width="10%" nowrap><ww:property value="quantity" /></td>
							<td class="text-center" width="10%" nowrap><ww:property value="unit_name" /></td>
							<td class="text-right" width="12%" nowrap>
							<ww:if test="amounttwo.length() == 0">
								&nbsp;
							</ww:if>
							<ww:else>
								<ww:property value="amounttwo" />
							</ww:else>	
							</td>
						</tr>
						<tr>
							<td class="text-right" nowrap>&nbsp;
							</td>
							<td class="text-right" nowrap>
							</td>
							<td class="text-center" nowrap><ww:property value="tax_div" /></td>
							<td class="text-right" nowrap>
							</td>
							
						</tr>
                      </ww:iterator>
                        
                      </tbody>
                      <tfoot>
                        <tr class="info">
                          <td class="headerSp" colspan="3" nowrap rowspan="3"></td>
                          <td class="text-center" nowrap colspan="3">合 計</td>
                          <td class="text-right" nowrap><ww:property value="form.estimate_amount_itiran" /></td>
                        </tr>
                        <tr class="info">
                          <td class="text-center" nowrap colspan="3">消費税
                          </td>
                          <td class="text-right" nowrap><ww:property value="form.tax_amount_itiran" />
                          </td>
                        </tr>
                        <tr class="info">
                          <td class="text-center" nowrap colspan="3">税込合計
                          </td>
                          <td class="text-right" nowrap><ww:property value="form.amount_itiran" />
                          </td>
                        </tr>
                      </tfoot>
                    </table>
                  </div>
                </div>
              </div>
            </div>

            <!--請求予定-->
            <div>
                <ul id="myTab" class="nav nav-tabs" role="tablist">
                  <li role="presentation" class="active"><a href="#detail" id="detail-tab" role="tab" data-toggle="tab" aria-controls="detail" aria-expanded="true">発注請求予定</a></li>
                </ul>
                <div class="panel panel-default">
                  <div id="myTabContent" class="tab-content">
                    <div role="tabpanel" class="tab-pane fade active in panel-body" id="detail" aria-labelledby="detail-tab">

                      <table class="table table-bordered" style="width:65rem;">
                        <thead>
                          <tr>
                            <td class="text-center" style="width:5rem;">枝番</td>
                            <td class="text-center" style="width:16rem;">請求予定日</td>
                            <td class="text-center" style="width:16rem;">支払予定日</td>
                            <td class="text-center" style="width:16rem;">請求予定金額</td>
                          </tr>
                        </thead>
                        <tbody id="tbOpthion">
                          <%int ss = 0; %>
                          <ww:iterator value="form.optionList" status="rows">
                          <tr>
							<td class="text-center" >
                              <input type="number" name="form.optionList[<ww:property value='#rows.index'/>].row_number" 
									value='<ww:property value="form.optionList[#rows.index].row_number"/>' class="form-control text-right"
									oninput="if(value.length>2)value=value.slice(0,2)" style="background-color:#fff" readonly/>
                            </td>
                            <td class="text-center"  >
                              <input type="date" name="form.optionList[<ww:property value='#rows.index'/>].order_date" 
									value='<ww:property value="form.optionList[#rows.index].order_date"/>' class="form-control" style="background-color:#fff" readonly/>
                            </td>
                            <td class="text-center" >
                              <input type="date" name="form.optionList[<ww:property value='#rows.index'/>].payment_date" 
									value='<ww:property value="form.optionList[#rows.index].payment_date"/>' class="form-control" style="background-color:#fff" readonly/>
                            </td>
                            <td class="text-right" >
                              <ww:property value='form.optionList[#rows.index].order_amount'/>
                            </td>		        	
                            
                          </tr>
						  <%  ss++; %>
                          </ww:iterator>
                        </tbody>
                      </table>
                    </div>
                  </div>
                </div>
            </div>
              
            <div class="row" style="margin:1rem 0 0 0.25rem">
              <div>
                <label for="state">備考（最大長度１２５０漢字）</label>
					<textarea class="form-control" rows="5" placeholder="備考" readonly><ww:property value="form.remark_itiran" /> 
                	</textarea>
              </div>
            </div>
            
             <div class="row" style="margin:1rem 0 0 0.25rem">
               <div>           
                 <label>社内メモ（最大長度１２５０漢字）</label>
					<textarea name="form.memo" class="form-control" rows="5" placeholder="社内メモ" readonly><ww:property value='form.memo'/>
                 	</textarea>
               </div>
             </div>
            <div class="form-group" style="margin-top:1.75rem;">
              <div>                  
                <ww:if test="form.page_flg.equals(\"6\")">
					<input type="button" class="btn btn-primary dora-sm-button" value="戻る" onclick="submitAction(this.form,'initialSiireSinki.action');">
				</ww:if>
				<ww:if test="form.page_flg.equals(\"7\")">
					<input type="button" class="btn btn-primary dora-sm-button" value="戻る" onclick="submitAction(this.form,'initialUpdateSiire.action');">
				</ww:if>
				<ww:if test="form.page_flg.equals(\"8\")">
					<input type="button" class="btn btn-primary dora-sm-button" value="戻る" onclick="submitAction(this.form,'showSiireItiran.action');">
				</ww:if>
				<ww:if test="form.page_flg.equals(\"9\")">
					<input type="button" class="btn btn-primary dora-sm-button" value="戻る" onclick="submitAction(this.form,'initialSiireSixyounin.action');">
				</ww:if>
				<ww:if test="form.page_flg.equals(\"10\")">
					<input type="button" class="btn btn-primary dora-sm-button" value="戻る" onclick="submitAction(this.form,'refreshHattyu.action');">
				</ww:if>
				<ww:if test="form.page_flg.equals(\"11\")">
					<input type="button" class="btn btn-primary dora-sm-button" value="戻る" onclick="submitAction(this.form,'refreshHattyu.action');">
				</ww:if>
				<ww:if test="form.page_flg.equals(\"12\")">
					<input type="button" class="btn btn-primary dora-sm-button" value="戻る" onclick="submitAction(this.form,'returnToShowDetailOneHattyu.action');">
				</ww:if>
				<ww:if test="form.page_flg.equals(\"13\")">
					<input type="button" class="btn btn-primary dora-sm-button" value="戻る" onclick="submitAction(this.form,'returnToRefreshAllHattyu.action');">
				</ww:if>
				<ww:if test="form.page_flg.equals(\"14\")">
					<input type="button" class="btn btn-primary dora-sm-button" value="戻る" onclick="submitAction(this.form,'refreshSaveTop.action');">
				</ww:if>
				<!-- sxt 20220718 add start -->
				<ww:if test="form.page_flg.equals(\"15\")">
					<input type="button" class="btn btn-primary dora-sm-button" value="戻る" onclick="submitAction(this.form,'showHattyuBunseki.action');">
				</ww:if>
				<!-- sxt 20220718 add end -->
				<!-- sxt 20220826 add start -->
				<ww:if test="form.page_flg.equals(\"16\")">
					<input type="button" class="btn btn-primary dora-sm-button" value="戻る" onclick="submitAction(this.form,'returnProjectDetail.action');">
				</ww:if>
				<!-- sxt 20220826 add end -->
				<!-- sxt 20220907 add start -->
				<ww:if test="form.page_flg.equals(\"2\")">
					<input type="button" class="btn btn-primary dora-sm-button" value="戻る" onclick="submitFunction(this.form,'returnTopAction.action')" />
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
    <ww:hidden name="'form.approval_div_name_itiran'" value="form.approval_div_name_itiran"></ww:hidden>
  </div>
</form>
</body>
<ww:include value="'/footerJs.jsp'" />
<script language="JavaScript">
function saveData(pForm,kbn){
	if (kbn=="ok"){	
		//承認"
		$("input[name='form.approval_div_name_itiran'").val("03");
		
	} else if (kbn=="ng"){
		//却下
		$("input[name='form.approval_div_name_itiran'").val("02");
	}
	
	pForm.action = "saveHattyuSixyounin.action";
	pForm.submit();	
}
</script>
</html>
