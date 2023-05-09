<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="ww" uri="webwork" %>
<html>
	<head>
	<meta http-equiv="content-type" content="text/html; charset=UTF-8">
		<link type="text/css" href="css/common.css" rel="stylesheet" />
		<script language="javascript" src="js/common.js"></script>
		<title>販売管理システム</title>
<script language="JavaScript">
	function submitAction(pForm,action){
		pForm.action = action;
		pForm.submit();	
	}
</script>	
</head>
<body>
<!-- Menu: -->
<ww:include value="'/menu.jsp'" />
<form name="HattyuForm" method="post">
<table border="0" width="100%" height="100%">
	<tr>
		
		<td valign="top">
          <table width="100%" align="center">
	        <tr>
		     <td class="title">&nbsp;&nbsp;日次処理 ＞ 承認 ＞ 発注</td>	
		      <td width="10%" align="right" class="title1" nowrap><ww:property value="#session.user_name" /></td>
	        </tr>
          </table>
    <br>
	<!-- 形式チェックエラーメッセージ -->
	<ww:if test="hasFieldErrors()">
		<table width="98%" align="center">
			<td align="left" nowrap>
				<font color="red" size="3"><b></b>
					<ww:iterator value="fieldErrors">
						<ww:iterator value="value" status="msg">
							<ww:property/><br>
						</ww:iterator>
					</ww:iterator>
				</font>
			</td>
		</table>
	</ww:if>
	<!-- 業務チェックエラーメッセージ -->
	<ww:if test="hasActionErrors()">
		<table width="98%" align="center">
			<td align="left" nowrap>
				<font color="red" size="3"><b></b>
					<ww:iterator value="actionErrors">
						<ww:property/><br>
					</ww:iterator>
				</font>
			</td>
		</table>	
	</ww:if>
	<!-- 正常なメッセージ -->
	<ww:if test="form.getMsg() != null && form.getMsg().length() > 0">
		<table width="98%" align="center">
			<td align="left" nowrap>
				<font color="red" size="3"><b></b>
					<ww:property value="form.msg" />
				</font>
			</td>
		</table>	
	</ww:if>
	
	
<ww:form name="'HattyuForm'" method="'POST'">
		<table width="98%" align="center">
			<tr>
				<td>
					<input type="button" class="button" value="戻る" onclick="submitAction(this.form,'returnTopAction.action')">
					<input type="button" class="button" value="保存" onclick="submitAction(this.form,'saveHattyuSixyounin.action');">
				</td>
			</tr>	
		</table>
		<br>
		<table border="0" width="98%" class="Frame" align="center">
			<tr>
				<td width="20"></td>
				<td>
					<table border="0" width="100%" align="center">
						<tr>
							<td width="10%">受注番号</td>
							<td width="1%"></td>
							<td width="6%">
							<a href="#" onclick="hrefHaveParamAction('jyutyuInfo.action?form.pageFlg=9&form.receive_no=<ww:property  value="form.receive_no_itiran" />')">
							<ww:property  value="form.receive_no_itiran" /></a></td>
							<td width="4%"></td>
							<td width="8%">受注日付</td>
							<td width="9%"><ww:property value="form.receive_date_itiran" /></td>
							<td width="1%"></td>
							<td width="40%">受注担当 <ww:property value="form.receive_in_name_itiran" /></td>
							<td></td>
						</tr>
						<tr>
							<td nowrap>件名</td>
							<td class="required"></td>
							<td colspan="6" nowrap ><ww:property value="form.receive_name1_itiran" /></td>
							<td class="required">
							</td>
							<td width="40%"> </td>
							<td></td>
						</tr>
						<tr>
							<td nowrap></td>
							<td class="required"></td>
							<td colspan="6" nowrap><ww:property value="form.receive_name2_itiran" /></td>
							<td class="required">
							</td>
							<td></td>
							<td></td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td width="20"></td>
				<td>
					<table border="0" width="100%" align="center">
						<tr>
							<td width="10%" nowrap>得意先コード</td>
							<td width="1%" class="required">
							</td>
							<td width="6%"><ww:property  value="form.customer_code_itiran" /></td>
							<td width="40%" colspan="4">
								<ww:property value="form.customer_name_itiran" />
							</td>
							<td width="5%">
							</td>
							<td width="1%"></td>
							<td width="10%"></td>
							<td width="1%"></td>
							<td></td>
						</tr>
						
						<tr>
							<td>支払条件</td>
							<td></td>
							<td colspan="4"><ww:hidden name ="'form.fraction_processing_itiran'" />							
								<ww:property value="form.payment_condition_itiran" />
							</td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
						</tr>
						
						
						<tr>
							<td>納品場所</td>
							<td></td>
							<td colspan="5"><ww:property value="form.delivery_place_itiran" />
							</td>
							<td></td>
							<td></td>
							<td>納品予定日</td>
							<td></td>
							<td colspan="5"><ww:property value="form.delivery_date_itiran" />
							</td>
						</tr>
						<tr>
							<td width="10%">請求区分</td>
							<td width="1%"></td>
							<td width="6%"><ww:property value="form.order_div_name_itiran"/></td>
							<td width="4%">
							</td>
							<td width="9%">作業期間</td>
							<td><ww:property value="form.work_start_date_itiran" /> ～ <ww:property value="form.work_end_date_itiran" />
							</td>
							<td>
							</td>
							<td></td>
							<td>
							</td>
							<td>
							</td>
							<td>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
		<br>
		<table border="0" width="98%" class="Frame" align="center">

			<tr>
				<td width="20"></td>
				<td>
					<table border="0" width="100%" align="center">
						<tr>
							<td width="11%">発注番号</td>
							<td width="10%">
								<ww:property value="form.order_no_itiran" />								
							<td width="4%"></td>
							<td width="12%"></td>
							<td width="1%"></td>
							<td width="20%" nowrap>発注担当者  <ww:property value="form.order_in_name_itiran" /></td>
							<td width="4%"></td>
							<td width="1%"></td>
							<td width="10%">
							</td>
							<td></td>
							<td>
							</td>
						</tr>
						<tr>
							<td width="10%">発注日付</td>
							<td>
								<table width="100%">
									<tr>
										<ww:property value="form.order_date_itiran" />
									</tr>
								</table>
							</td>
							<td></td>
							<td>外注見積番号</td>
							<td class="required"></td>
							<td>
								<ww:property value="form.out_estimate_no_itiran"/>
							</td>
							<td></td>
							<td></td>
							<td>月次締(<ww:property value ="form.month_close_Name_itiran" />)</td>
							<td></td>
							<td>発注書発行(<ww:property value ="form.order_print_name_itiran" />)</td>
						</tr>
					</table>
					<table border="0" width="100%" align="center">
						<tr>
							<td width="11%">件名１</td>
							<td colspan="4" class="input" nowrap>
								<ww:property value="form.order_name1_input_itiran" /></td>
							<td class="required">
							</td>
							<td>
							</td>
							<td></td>
						</tr>
						<tr>
							<td nowrap>件名２</td>
							<td colspan="4" class="input" nowrap>
								<ww:property value="form.order_name2_input_itiran" /></td>
							<td class="required">
							</td>
							<td>
							</td>
							<td></td>
						</tr>
						
						
						<tr>
							<td width="10%">外注先</td>
							<td width="6%">
								<ww:property value="form.out_order_code_itiran" /></td>
							<td width="45%" nowrap>
								&nbsp;&nbsp;<ww:property value="form.out_order_name_itiran"/></td>
							<td>
							</td>
							<ww:hidden name="'form.processing'"> </ww:hidden>
						</tr>
						<tr>
							<td width="10%">支払条件</td>
							<td width="40%" colspan="2">
								<ww:property value="form.payment_condition_input_itiran" /></td>
							<td width="5%">
							</td>
							<td>
							</td>
						</tr>
					</table>
					
					<table border="0" width="100%" align="center">
						<tr>
							<td width="10%">請求区分</td>
							<td width="1%"></td>
							<td width="8%"><ww:property value="form.Order_div_name_itirantwo"/></td>
							<td width="1%"></td>
							<td width="4%">
							</td>
							<td width="8%">納品日</td>
							<td width="20%">
								<ww:property value="form.delivery_date_itiran"/>
							</td>
							<td width="10%"></td>
							<td width="10%">支払予定日</td>

							<td width="20%">
								<ww:property value="form.payment_date_itiran"/>
							</td>
							<td></td>
						</tr>
						<tr>
							<td width="8%">納品状況</td>
							<td width="1%">
							</td>
							<td width="6%"><ww:property value="form.delivery_status_name"/></td>
							<td width="1%">
							</td>
							<td>
							</td>
							<td width="9%">作業期間</td>
							<td><ww:property value="form.work_start_date_itirantwo" /> ～ <ww:property value="form.work_end_date_itirantwo" />
							</td>
							<td>
							</td>
							<td></td>
							<td>

							</td>
							<td>
							</td>
							<td>
							</td>
						</tr>
						<tr>
						<td width="10%">消費税率(%)</td>
							<td width="1%" class="required"></td>
							<td width="8%">
								<ww:property value="form.consume_tax_rate_itiran"/>
							</td>
							<td width="1%">
							</td>
							<td>
							</td>
							<td>
							</td>
							<td>
							</td>

							<td>
							</td>							
							<td>承認	</td>
							<td width="50">

							<ww:select name="'form.approval_div_name_itiran'"
						       		cssStyle="'WIDTH:47px'" 
						       		list="form.approval_divlist" 
						       		listKey="code_id" 
						       		listValue="code_value" 
						       		value="form.approval_div_name_itiran" >
				   				</ww:select> 

				   			</td>
						</tr>
						<tr>
							<td width="10%"></td>
							<td width="1%" class="required"></td>
							<td width="8%"></td>
							<td width="1%">
							</td>
							<td>
							</td>
							<td>
							</td>
							<td>
							</td>
							<td>
							</td>
							<td>
							</td>
							<td>
							</td>
							<td width="1%" class="required">
							</td>
							<td>
							</td>
							<td>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
		<br>
		
		<ww:if test="form.stockDetailModelList_itiran.size>0">
		<table border="1" width="98%" align="center">
			<thead>
				<tr>
					<td class="headerSpCT" width="3%" nowrap rowspan="2">行</td>
					<td class="headerSpCT" nowrap rowspan="2" colspan="2">作業内容</td>
					<td class="headerSpCT" width="10%" nowrap rowspan="2">単価</td>
					<td class="headerSpCT" width="10%" nowrap rowspan="2">数量</td>
					<td class="headerSpCT" width="12%" nowrap >単位</td>
					<td class="headerSpCT" width="12%" rowspan="2">金額</td>
				</tr>
				<tr>
					<td class="headerSpCT" nowrap>税区分</td>
				</tr>
			</thead>
			<tbody id="tbAddPart">
			
				<ww:iterator value="form.stockDetailModelList_itiran" status="rows" >
				<ww:if test="#rows.odd == true">
				<tr>
					<td class="itemCT" width="3%" nowrap rowspan="2"><ww:property value="row_number" /></td>
					<td class="itemLF" nowrap rowspan="2" colspan="2" width="500" style="word-break:break-all" ><ww:property value="task_content" /></td>
					<td class="itemR" width="10%" nowrap><ww:property value="price_per" /></td>
					<td class="itemR" width="10%" nowrap><ww:property value="quantity" /></td>
					<td class="itemCT" width="10%" nowrap><ww:property value="unit_name" /></td>
					<td class="itemR" width="12%" nowrap>
					<ww:if test="amounttwo.length() == 0">
						&nbsp;
					</ww:if>
					<ww:else>
						<ww:property value="amounttwo" />
					</ww:else>	
					</td>
				</tr>
				<tr>
					<td class="itemR" nowrap>&nbsp;
					</td>
					<td class="itemR" nowrap>
					</td>
					<td class="itemCT" nowrap><ww:property value="tax_div" /></td>
					<td class="itemR" nowrap>
					</td>					
				</tr>
				</ww:if>
				<ww:else>
				<tr>
					<td class="itemGreyCT" width="3%" nowrap rowspan="2"><ww:property value="row_number" /></td>
					<td class="itemGreyLF" nowrap rowspan="2" colspan="2"width="500" style="word-break:break-all"><ww:property value="task_content" /></td>
					<td class="itemGreyR" width="10%" nowrap><ww:property value="price_per" /></td>
					<td class="itemGreyR" width="10%" nowrap><ww:property value="quantity" /></td>
					<td class="itemGreyCT" width="10%" nowrap><ww:property value="unit_name" /></td>
					<td class="itemGreyR" width="12%" nowrap>
					<ww:if test="amounttwo.length() == 0">
						&nbsp;
					</ww:if>
					<ww:else>
						<ww:property value="amounttwo" />
					</ww:else>	
					</td>
				</tr>
				<tr>
					<td class="itemGreyR" nowrap>&nbsp;
					</td>
					<td class="itemGreyR" nowrap>
					</td>
					<td class="itemGreyCT" nowrap>
					<ww:property value="tax_div" />
					</td>
					<td class="itemGreyR" nowrap>					
					</td>
				</tr>					
				</ww:else>				
				</ww:iterator>
			
				<tfoot>
					<tr>
						<td class="headerSp" colspan="3" nowrap rowspan="3"></td>
						<td class="headerSpCT" nowrap colspan="3">合 計</td>
						<td class="headerSpR" nowrap><ww:property value="form.estimate_amount_itiran" /></td>						
					</tr>
					<tr>
						<td class="headerSpCT" nowrap colspan="3">消費税
						</td>
						<td class="headerSpR" nowrap><ww:property value="form.tax_amount_itiran" />
						</td>
					</tr>
					<tr>
						<td class="headerSpCT" nowrap colspan="3">税込合計
						</td>
						<td class="headerSpR" nowrap><ww:property value="form.amount_itiran" />
						</td>
					</tr>
				</tfoot>
		</table>
		</ww:if>
		<br>
		<table width="98%" align="center">
			<tr>
				<td nowrap>備考（最大長度１２５０漢字）</td>
			</tr>
			<tr>
				<td class="itemLF" width="985" style="word-break:break-all" cols="157" rows="3">
					<div style="OVERFLOW-Y:auto;HEIGHT:80px;border-top-color:#FFFFFF;border-right-color:#FFFFFF;border-bottom-color:#FFFFFF;border-left-color:#FFFFFF;"> 
						<ww:property value="form.remark_itiran" /> 
					</div>
				</td>
				
				
			</tr>
		</table>		
		
		<br>
		<table width="98%" align="center">
			<tr>
				<td>
					<input type="button" class="button" value="戻る" onclick="submitAction(this.form,'returnTopAction.action')">
					<input type="button" class="button" value="保存" onclick="submitAction(this.form,'saveHattyuSixyounin.action');">
				</td>
			</tr>	
		</table>
		
</ww:form>
		<br>
	</body>
</html>

