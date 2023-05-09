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
<style type="text/css">
	div.openList{
	width:100%;
    top:0px;
    left:14px;
    bottom:0px;
    text-align: left;
    position: relative;
    background: transparent;
	margin:0px auto 15px auto;
	float: left;
	}
</style>
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
		      <td class="title">&nbsp;&nbsp;レポート ＞ 発注一覧 ＞ 発注明細</td>
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
				<td><input type="button" class="button" value="戻る" onclick="submitAction(this.form,'showHattyuBunseki.action');"></td>
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
							<a href="#" onclick="hrefHaveParamAction('jyutyuInfo.action?form.pageFlg=8&form.receive_no=<ww:property  value="form.receive_no_itiran" />')">
							<ww:property  value="form.receive_no_itiran" /></a></td>
							<td width="4%"></td>
							<td width="8%">受注日付</td>
							<td width="9%"><ww:property value="form.receive_date_itiran" /></td>
							<td width="1%"></td>
							<td width="20%">受注担当 <ww:property value="form.receive_in_name_itiran" /></td>
							<td width="40%">見積番号 <ww:property value="form.estimate_no" /></td>
						</tr>
						<tr>
							<td nowrap>件名</td>
							<td class="required"></td>
							<td colspan="6" nowrap><ww:property value="form.receive_name1_itiran" /></td>
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
							<td width="40%" colspan="4" nowrap>
								&nbsp;&nbsp;<ww:property value="form.customer_name_itiran" />
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
							<td width="12%">承認(<ww:property value="form.approval_div_name_itiran" />)</td>
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
							<td colspan="4" class="input">
								<ww:property value="form.order_name1_input_itiran" /></td>
							<td class="required">
							</td>
							<td>
							</td>
							<td></td>
						</tr>
						<tr>
							<td nowrap>件名２</td>
							<td colspan="4" class="input">
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
							<td width="6%"><ww:property value="form.Order_div_name_itirantwo"/></td>
							<td width="4%">
							</td>

							<td width="1%"></td>

							<td width="8%">納品日</td>
							<td>
								<ww:property value="form.delivery_date_itirantwo"/>
							</td>
							<td width="10%">支払予定日</td>
							<td width="1%"></td>
							<td width="24%">
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
						<td>消費税率(%)</td>
							<td width="1%" class="required"></td>
							<td>
								<ww:property value="form.consume_tax_rate_itiran"/>
							</td>
							<td></td>
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
		<div class="openList" >
		<table border="0"  align="left">
			<thead>
				<tr>
					<td class="headerSpCT" width="40px" nowrap >行</td>
					<td class="headerSpCT" nowrap width="300px">作業内容</td>
					<td class="headerSpCT" width="150px" nowrap >単価</td>
					<td class="headerSpCT" width="150px" nowrap >数量</td>
					<td class="headerSpCT" width="100px" nowrap>単位</td>
					<td class="headerSpCT" width="150px" >金額</td>
				</tr>
			</thead>
			<tbody id="tbAddPart">
			
				<ww:iterator value="form.stockDetailModelList_itiran" status="rows" >
				<ww:if test="#rows.odd == true">
				<tr>
					<td class="itemCT"  nowrap ><ww:property value="row_number" /></td>
					<td class="itemLF" nowrap   style="word-break:break-all" ><ww:property value="task_content" /></td>
					<td class="itemR" nowrap><ww:property value="price_per" /></td>
					<td class="itemR"  nowrap><ww:property value="quantity" /></td>
					<td class="itemCT"  nowrap><ww:property value="unit_name" /></td>
					<td class="itemR"  nowrap>
					<ww:if test="amounttwo.length() == 0">
						&nbsp;
					</ww:if>
					<ww:else>
						<ww:property value="amounttwo" />
					</ww:else>	
					</td>
				</tr>
				
				</ww:if>
				<ww:else>
				<tr>
					<td class="itemGreyCT"  nowrap ><ww:property value="row_number" /></td>
					<td class="itemGreyLF" nowrap  style="word-break:break-all"><ww:property value="task_content" /></td>
					<td class="itemGreyR"  nowrap><ww:property value="price_per" /></td>
					<td class="itemGreyR"  nowrap><ww:property value="quantity" /></td>
					<td class="itemGreyCT"  nowrap><ww:property value="unit_name" /></td>
					<td class="itemGreyR"  nowrap>
					<ww:if test="amounttwo.length() == 0">
						&nbsp;
					</ww:if>
					<ww:else>
						<ww:property value="amounttwo" />
					</ww:else>	
					</td>
				</tr>
							
				</ww:else>				
				</ww:iterator>
			
				
		</table>
		</div>
		</ww:if>
		<br>
		
	<ww:if test="form.optionList.size>0">
	<div class="openList" >
	<table border="0" align=left>
		<thead>
		<tr>
			<td class="headerSpCT" width="40px" >行</td>
			<td class="headerSpCT" width="100px" >請求日</td>
			<td class="headerSpCT" width="100px" >支払予定日</td>
			<td class="headerSpCT" width="150px" >支払予定金額</td>
		</tr>
		</thead>
		<tbody id="tbAddPart">
		<%int s = 0; %>
        <ww:iterator value="form.optionList" status="rows">
			<ww:if test="#rows.odd == true">
			<tr>	
				<td class="itemCT"  ><%= s+1 %></td>
				<td class="itemCT" >
					&nbsp;<ww:property value="orderYear" />/<ww:property value="orderMonth" />/<ww:property value="orderDay" />
				</td>
				<td class="itemCT" >
					&nbsp;<ww:property value="paymentYear" />/<ww:property value="paymentMonth" />/<ww:property value="paymentDay" />
				</td>
				<td class="itemR">
					&nbsp;<ww:property value="order_amount" />
				</td>
			</tr>
			</ww:if>			
			<ww:else>
			<tr>			
				<td class="itemGreyCT" ><%= s+1 %></td>
				<td class="itemGreyCT" >
					&nbsp;<ww:property value="orderYear" />/<ww:property value="orderMonth" />/<ww:property value="orderDay" />
				</td>
				<td class="itemGreyCT" >
					&nbsp;<ww:property value="paymentYear" />/<ww:property value="paymentMonth" />/<ww:property value="paymentDay" />
				</td>
				<td class="itemGreyR">
					&nbsp;<ww:property value="order_amount" />
				</td>
			</tr>
			</ww:else>
		<%s++; %>		
		</ww:iterator>
		</tbody>
	</table>
	</div>
	</ww:if>
	<br>
	<div class="openList" >
		<table  width="60%" align="left">
			<tr>
				<td nowrap>備考</td>
			</tr>
			<tr>
				<td class="itemLF" width="985" style="word-break:break-all" cols="157" rows="3">
					<div style="OVERFLOW-Y:auto;HEIGHT:80px;border-top-color:#FFFFFF;border-right-color:#FFFFFF;border-bottom-color:#FFFFFF;border-left-color:#FFFFFF;"> 
						<ww:property value="form.remark_itiran" /> 
					</div>
				</td>
				
				
			</tr>
		</table>		
	</div>
		<br>
		<table width="98%" align="center">
			<tr>
				<td><input type="button" class="button" value="戻る" onclick="submitAction(this.form,'showHattyuBunseki.action');"></td>
			</tr>
		</table>
		
</ww:form>
		<br>
	</body>
</html>
