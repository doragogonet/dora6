<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="ww" uri="webwork" %>

<html lang="ja">
<head>
<ww:include value="'/headContent.jsp'" />
<title>売上分析一覧画面</title>
<script language="JavaScript">
	function submitAction(pForm,action){
		pForm.action = action;
		pForm.submit();	
	}
</script>
</head>

<body class="cm-no-transition cm-1-navbar">
<form name="uriageBunsekiForm" action="showUriageBunseki.action" method="POST" class="form-horizontal">
  <header id="cm-header">
<!--     <nav class="cm-navbar cm-navbar-primary"> -->
<!--       <div class="cm-flex"> -->
<!--         <h1>帳票 -->
<!--           <i class="fa fa-fw fa-angle-double-right"></i> -->
<!--           売上 -->
<!--           <i class="fa fa-fw fa-angle-double-right"></i> -->
<!--           <span> -->
<!--             売上一覧 -->
<!--           </span> -->
<!--         </h1> -->
<!--       </div> -->
<%--       <ww:include value="'/header.jsp'"/> --%>
<!--     </nav> -->
  </header>
  <div id="global">
    <div class="container-fluid">
      <div class="text-center dora-form-title">
        売上分析一覧画面
        <ww:include value="'/loginName.jsp'"/>
      </div>
      <div class="panel panel-default">
        <div class="panel-body">
        
            <ww:include value="'/message.jsp'" />

            <!--ヘッダー-->
            <div class="form-group form-inline">
              <label class="dora-label-left">売上年月</label>
              <input type="month" name="form.uriage_date_start" value="<ww:property value='form.uriage_date_start'/>" class="form-control">
              <label>～</label>
              <input type="month" name="form.uriage_date_end" value="<ww:property value='form.uriage_date_end'/>" class="form-control">
            </div>
            <div class="form-group form-inline">
              <label class="dora-label-left">請求先コード</label>
              <input type="text" name="form.request_code_start" value="<ww:property value='form.request_code_start'/>" maxlength="8" class="form-control" placeholder="請求先コード">
<!--               <label>～</label> -->
              <input type="text" name="form.request_code_end" value="<ww:property value='form.request_code_end'/>" maxlength="8" class="form-control" placeholder="請求先コード">
            </div>
            <div class="form-group form-inline">
              <label class="dora-label-left">売上担当者</label>
              <ww:select name="'form.uriage_in_code'" 
						   cssClass="'form-control'" 
						   cssStyle="'width:20rem'" 
						   list="form.uriageTantosyaList" 
						   listKey="person_in_charge_code" 
						   listValue="person_in_charge_name" 
					       value="form.uriage_in_code"
					       headerKey="''"
					       headerValue="'全て'"
					>
				</ww:select>
				
				
            </div>
            <div class="form-group" style="margin-top:1rem;">
              <div>
                <button type="button" class="btn btn-primary dora-sm-button" onclick="submitAction(this.form,'showUriageBunseki.action');">検索</button>
              </div>
            </div>
            
            <!-- リストコンテント -->
            <div class="form-group" style="margin-top:1.75rem">
	            <ww:if test="form.uriageDataList.size>0 && hasFieldErrors()==false && hasActionErrors()==false ">
	            
		            <table class="table table-bordered table-hover">
	                <thead>
	                  <tr>
	                    <td class="text-center" width="15%" nowrap>請求先コード</td>
	                    <td class="text-center" nowrap>請求先</td>
	                    <td class="text-center" width="18%" nowrap><a href="#" onclick="hrefAction('showSalesSuiiItiran.action')">売上金額</a><br>（入金金額）</td>
	                    <td class="text-center" width="18%" nowrap>外注金額</td>
	                    <td class="text-center" width="18%" nowrap>差益</td>
	                  </tr>
	                  <tr>
	                    <td class="text-center" colspan="2">合　計</td>
	                    <ww:if test="form.uriage_stock_amount == null || form.uriage_stock_amount.equals(\"\")">
							<td class="text-right"><ww:property value="form.uriage_stock_amount"/>
								<ww:if test="form.nyuukin_amount == null || form.nyuukin_amount.equals(\"\")">
									<br>（0）
								</ww:if>
								<ww:else>
									<br>（<ww:property value="form.nyuukin_amount"/>）
								</ww:else>
							</td>
						</ww:if>
						<ww:else>
							<td class="text-right">
							<ww:property value="form.uriage_stock_amount"/>
								<ww:if test="form.nyuukin_amount == null || form.nyuukin_amount.equals(\"\")">
									<br>（0）
								</ww:if>
								<ww:else>
									<br>（<ww:property value="form.nyuukin_amount"/>）
								</ww:else>
							</td>
						</ww:else>
						<ww:if test="form.gaiqyuu_stock_amount == null || form.gaiqyuu_stock_amount.equals(\"\")">
							<ww:if test="form.uriage_in_code == null || form.uriage_in_code.equals(\"\")">	<!-- sxt 20230407 add -->
							<td class="text-right"><ww:property value="form.gaiqyuu_stock_amount"/></td>
							<!-- sxt 20230407 add start -->
							</ww:if>
							<ww:else>
								<td class="text-right"></td>
							</ww:else>
							<!-- sxt 20230407 add end -->
						</ww:if>
						<ww:else>
							<ww:if test="form.uriage_in_code == null || form.uriage_in_code.equals(\"\")">	<!-- sxt 20230407 add -->
							<td class="text-right"><ww:property value="form.gaiqyuu_stock_amount"/></td>
							<!-- sxt 20230407 add start -->
							</ww:if>
							<ww:else>
								<td class="text-right"></td>
							</ww:else>
							<!-- sxt 20230407 add end -->
						</ww:else>
						<ww:if test="form.saeki_amount.equals(\"0\")">
							<td class="text-right"></td>
						</ww:if>
						<ww:else>
							<ww:if test="form.uriage_in_code == null || form.uriage_in_code.equals(\"\")">	<!-- sxt 20230407 add -->
							<td class="text-right"><ww:property value="form.saeki_amount"/></td>
							<!-- sxt 20230407 add start -->
							</ww:if>
							<ww:else>
								<td class="text-right"></td>
							</ww:else>
							<!-- sxt 20230407 add end -->
						</ww:else>
	                  </tr>
	                </thead>
	                <tbody>
	                <ww:iterator value="form.uriageDataList" status="rows">
	                	<% String trClass = ""; %>
						<ww:if test="#rows.odd == true">
							<% trClass = "success"; %>
						</ww:if>
						
						<tr class="<%=trClass%>">
		                    <td class="text-center"><ww:property value="order_first_code"/></td>
		                    <td style="word-break:break-all"><ww:property value="customer_name"/></td>
		                    <ww:if test="sales_amount == null || sales_amount.equals(\"\")">
								<td class="text-right">
									<a href="#" onclick="hrefHaveParamAction('showUriageSuiiMeisai.action?form.request_code=<ww:property value='order_first_code'/>&form.fromPageFlag=1');"><ww:property value="sales_amount"/></a> 
									<ww:if test="receipt_amount == null || receipt_amount.equals(\"\")">
										<br>（0）
									</ww:if>
									<ww:else>
										<br>（<ww:property value="receipt_amount"/>）
									</ww:else>
								</td>
							</ww:if>
							<ww:else>
								<td class="text-right">
									<a href="#" onclick="hrefHaveParamAction('showUriageSuiiMeisai.action?form.request_code=<ww:property value='order_first_code'/>&form.fromPageFlag=1');"><ww:property value="sales_amount"/></a> 
									<ww:if test="receipt_amount == null || receipt_amount.equals(\"\")">
										<br>（0）
									</ww:if>
									<ww:else>
										<br>（<ww:property value="receipt_amount"/>）
									</ww:else>
								</td>
							</ww:else>
							<ww:if test="stock_amount == null || stock_amount.equals(\"\")">
								<ww:if test="form.uriage_in_code == null || form.uriage_in_code.equals(\"\")">	<!-- sxt 20230407 add -->
								<td class="text-right"><ww:property value="stock_amount"/></td>
								<!-- sxt 20230407 add start -->
								</ww:if>
								<ww:else>
									<td class="text-right"></td>
								</ww:else>
								<!-- sxt 20230407 add end -->
							</ww:if>
							<ww:else>
								<ww:if test="form.uriage_in_code == null || form.uriage_in_code.equals(\"\")">	<!-- sxt 20230407 add -->
								<td class="text-right"><ww:property value="stock_amount"/></td>
								<!-- sxt 20230407 add start -->
								</ww:if>
								<ww:else>
									<td class="text-right"></td>
								</ww:else>
								<!-- sxt 20230407 add end -->
							</ww:else>
							<ww:if test="form.uriage_in_code == null || form.uriage_in_code.equals(\"\")">	<!-- sxt 20230407 add -->
							<td class="text-right"><ww:property value="saeki"/></td>
							<!-- sxt 20230407 add start -->
							</ww:if>
							<ww:else>
								<td class="text-right"></td>
							</ww:else>
							<!-- sxt 20230407 add end -->
		                </tr>
	                </ww:iterator>
	                </tbody>
	              </table>
	            
	            </ww:if>
            </div>
			<ww:hidden name="'form.uriage_date_start_hidden'"></ww:hidden>	
		 	<ww:hidden name="'form.uriage_date_end_hidden'"></ww:hidden>	
		 	<ww:hidden name="'form.request_code_start_hidden'"></ww:hidden>	
		 	<ww:hidden name="'form.request_code_end_hidden'"></ww:hidden>	
		 	<ww:hidden name="'form.uriage_in_code_hidden'"></ww:hidden>	
        </div>
      </div>
    </div>
    <ww:include value="'/footer.jsp'" />
  </div>
</form>
</body>
<ww:include value="'/footerJs.jsp'" />
</html>