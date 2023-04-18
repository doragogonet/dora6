<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="ww" uri="webwork" %>
<html lang="ja">
	<head>
		<ww:include value="'/headContent.jsp'" />
		<title>仕入（請負）新規画面</title>
<script language="JavaScript">
	function submitAction(pForm,action){
		pForm.action = action;
		pForm.submit();	
	}
	function deleteSinkiSiire(pForm){
		var len = document.SiireForm.elements.length;
		var count=0;
		for (i=0; i<len; i++) {
			var strName=document.SiireForm.elements[i].name;
			var lastStr = strName.substr(strName.length-5,strName.length);
			
			if (lastStr == "Check"){
				if (document.SiireForm.elements[i].checked == true){	
				    count = 1;
				}
			}
		}			
		if (count == 0){
			alert("削除したい明細を選択してください。" );
		}else{
			if (confirm("削除してよろしいでしょうか？")==true){
				//sxt 20220628 del start
				//document.SiireForm.action="deleteSinkiSiire.action";
				//document.SiireForm.submit();
				//sxt 20220628 del end
				return true;	//sxt 20220628 add
			}
		}
	}
	function priceCalAmount(pForm,index){
	
		var amount =0;
		var price =  document.SiireForm.elements['form.stockDetailModelList['+index +'].price_per'].value;
		var quantity = document.SiireForm.elements['form.stockDetailModelList['+index +'].quantity'].value;
		var fraction_processing = "";
		if(document.SiireForm.elements['form.fraction_processing']!=null){
			fraction_processing = document.SiireForm.elements['form.fraction_processing'].value;
		}
		if(price!="" && checkHan(price)==false){
			return ;
		}
		if(quantity!="" && checkMinHan(quantity)==false){
			return ;
		}
		if(price=="" && quantity==""){
			amount="";
		}else{
			if(checkNumber(price)==true && checkKingaku(quantity)==true){
				amount = price * quantity;
				if(fraction_processing!=""){
					if(fraction_processing =="02"){
						amount = Math.round(amount);
					}else if(fraction_processing =="01"){
						amount = Math.floor(amount);
					}else if(fraction_processing =="03"){
						if(amount>Math.floor(amount)){
							amount = Math.floor(amount)+1 ;
						}
					}			
				}
			}		
		}
		document.SiireForm.elements['form.stockDetailModelList['+index +'].amount'].value = amount;			
	}
	function checkNumber(varStr){
		var data;
		var ret;
		for ( var i = 0; i < varStr.length; i++ ) {
			data = varStr.substr( i, 1 );
			ret = data.match(/^\d+$/);
			if ( data != ret ) {
				return false;
			}
		}
	    return true;
	}

	function checkKingaku(varStr){
		
		var testStr = /(^-\d{0,4}\.\d\d?$)|(^-\d{0,4}$)|(^\d{0,4}\.\d\d?$)|(^\d{0,4}$)/;
		return  testStr.test(varStr); 
	}
	function checkMinHan(varStr){
				var testStr = /^-([0-9]+).\d\d?$|^([0-9]+).\d\d?$|-([0-9]+)$|([0-9]+)$/;
				return  testStr.test(varStr); 
			}	
	function checkHan(varStr){
				var testStr = /^([0-9]+)$/;
				return  testStr.test(varStr); 
			}
				
</script>		
</head>
<body onunload="closeSubWindow();" class="cm-no-transition cm-1-navbar">
<form name="SiireForm" method="POST" class="form-horizontal">
	<header id="cm-header">
<!--       <nav class="cm-navbar cm-navbar-primary"> -->
<!--         <div class="cm-flex"> -->
<!--           <h1>仕入処理 -->
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
          仕入（請負）新規画面
          <ww:include value="'/loginName.jsp'"/>       
        </div>
        <div class="panel panel-default">
          <div class="panel-body">
            
            <ww:include value="'/message.jsp'" />
              
              <!--button-->              
              <div class="form-group">
                <div>
					<ww:if test="form.pageId.equals(\"4\")">
						<button type="button" class="btn btn-primary dora-sm-button" onclick="submitAction(this.form,'showSiireYoteiItiran.action');">戻る</button>
					</ww:if>
					<ww:else>
						<!-- sxt 20220712 del start -->
<!-- 						<button type="button" class="btn btn-primary dora-sm-button" onclick="submitAction(this.form,'refreshSiire.action');">戻る</button> -->
						<!-- sxt 20220712 del end -->
						<!-- sxt 20220712 add start -->
						<ww:if test="form.modoruFlg.equals(\"1\")">
						    <button type="button" class="btn btn-primary dora-sm-button" onclick="hrefAction('returnProjectDetail.action')">戻る</button>
						</ww:if>
						<ww:else> 
						    <button type="button" class="btn btn-primary dora-sm-button" onclick="submitAction(this.form,'refreshSiire.action');">戻る</button>
						</ww:else>
						<!-- sxt 20220712 add end -->
					</ww:else> 
					<!-- sxt 20220721 del start -->
<!-- 					<button type="button" class="btn btn-primary dora-sm-button" onclick="submitAction(this.form,'saveSinkiSiire.action');">保存</button> -->
					<!-- sxt 20220712 del end -->
					<!-- sxt 20220721 add start -->
					<ww:if test="form.modoruFlg.equals(\"1\")">
					    <button type="button" class="btn btn-primary dora-sm-button" onclick="submitAction(this.form,'saveSinkiSiireFromProject.action');">保存</button>
					</ww:if>
					<ww:else> 
					    <button type="button" class="btn btn-primary dora-sm-button" onclick="submitAction(this.form,'saveSinkiSiire.action');">保存</button>
					</ww:else>
					<!-- sxt 20220712 add end -->
                </div>
              </div>
              
              <!--状態区域-->
                <div class="panel-body" style="padding:1.75rem 1rem">
                  <div class="dora-state-zone">月次締(<ww:property value ="form.month_close_Name" />)</div>
                  <div class="dora-state-zone">支払(<ww:property value ="form.stock_payment_Name" />)</div>
                  
                  <div class="dora-state-zone form-inline">
                  	<label class="dora-label-right">仕入担当者</label>
                    <ww:select name="'form.stock_in_code_new'"
			              size="'1'" 
					      cssClass="'form-control'" 
					      list="form.stock_in_namelist_ForSel" 
					      listKey="person_in_charge_code" 
					      listValue="person_in_charge_name" 
					      value="form.stock_in_code_new"  >
			   		</ww:select>
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
                        <label class="dora-label-normal btn-link" onclick="linkAction('showHattyuItiran.action?form.order_no_itiran=<ww:property  value="form.order_no" />&form.page_flg=6','');"><ww:property  value="form.order_no" /></label>
                        <label class="dora-label-right">発注日付</label>
                        <label class="dora-label-normal"><ww:property value="form.order_date" /></label>
                      </div>

                      <div class="form-group form-inline">
                        <label class="dora-label-left">得意先</label>
                        <label class="dora-label-normal"><ww:property  value="form.customer_code" />　<ww:property value="form.customer_name" /></label>
                        <ww:hidden name ="'form.fraction_processing'" />
                      </div>

                      <div class="form-group form-inline">
                        <label class="dora-label-left">件名 </label>
                        <label class="dora-label-normal"><ww:property  value="form.stock_name1_hachu" />　<ww:property  value="form.stock_name2_hachu" /></label>
                      </div>

                      <div class="form-group form-inline">
                        <label class="dora-label-left">外注先 </label>
                        <label class="dora-label-normal"><ww:property value="form.out_order_code" />　<ww:property value="form.out_order_name" /></label>
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
                        <label class="dora-label-left-require">仕入番号</label>
                        <input type="text" name="form.stock_no" value="<ww:property value='form.stock_no'/>" maxlength="25" class="form-control" placeholder="仕入番号">
                        <label class="dora-label-right-require">仕入日付</label>
                        <input type="date" name="form.stock_date"  value="<ww:property value='form.stock_date'/>" class="form-control">
                        <label class="dora-label-right">外注請求番号</label>
                        <input type="text" name="form.out_order_no" value="<ww:property value='form.out_order_no'/>" maxlength="20" class="form-control" placeholder="外注請求番号">
                      </div>
                      
					  <div class="form-group form-inline">
                        <label class="dora-label-left-require">件名</label>
                        <input type="text" name="form.stock_name1" value="<ww:property value='form.stock_name1'/>" maxlength="60" class="form-control" style="width:40rem;" placeholder="件名１">
                        <input type="text" name="form.stock_name2" value="<ww:property value='form.stock_name2'/>" maxlength="60" class="form-control" style="width:40rem;" placeholder="件名２">
                      </div>

                      <div class="form-group form-inline">
                        <label class="dora-label-left-require">作業期間</label>
                        <input type="date" name="form.work_start_date" value="<ww:property value='form.work_start_date'/>" class="form-control">
                        <label>～</label>  
                        <input type="date" name="form.work_end_date" value="<ww:property value='form.work_end_date'/>" class="form-control">
                        
                      </div>

                      <div class="form-group form-inline">
                        <label class="dora-label-left">納品状況</label>
                        <ww:select name="'form.delivery_status_input'" 
								   cssStyle="'width:16rem'" 
                                   cssClass="'form-control'"
								   list="form.delivery_status" 
								   listKey="code_id" 
								   listValue="code_value" 
								   value="form.delivery_status_input" 
								   
						>
						</ww:select>

                        <label class="dora-label-right">支払予定日</label>
                        <input type="date" name="form.payment_date" value="<ww:property value='form.payment_date'/>" class="form-control">
                        <label class="dora-label-right-require">消費税率(%)</label>
                        <input type="number" name="form.consume_tax_rate" value="<ww:property value='form.consume_tax_rate'/>" class="form-control" style="width: 8rem;" placeholder="税率(%)"  
                        		oninput="maxNumberLength(2)" onKeypress="return integerOnly()"/>
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
                            <td class="text-center" rowspan="2" colspan="2" style="width:20rem;">作業内容</td>
                            <td class="text-center" rowspan="2" style="width:18rem;">単価</td>
                            <td class="text-center" rowspan="2" style="width:14rem;">数量</td>
                            <td class="text-center" style="width:16rem;">単位</td>
                            <td class="text-center" rowspan="2" style="width:18rem;">金額</td>
                            <td class="text-center" rowspan="2" style="width:2rem;"></td>
                          </tr>
                          <tr>
                            <td class="text-center" nowrap>税区分</td>
                            <ww:hidden name="'detailsize'" id="detailsize" value="form.stockDetailModelList.size()"></ww:hidden>
                          </tr>
                        </thead>
                        <tbody id="tbAddPart">
                          <%int temp = 0 ;%>
						  <ww:iterator value="form.stockDetailModelList" status="rows" id="model">
							<tr>
                            <td class="text-center" rowspan="2">
                              <input type="number" name="form.stockDetailModelList[<ww:property value='#rows.index'/>].row_number" 
									value='<ww:property value="form.stockDetailModelList[#rows.index].row_number"/>' class="form-control text-right"
									oninput="maxNumberLength(2)" onKeypress="return integerOnly()"/>
                            </td>
                            <td class="text-center" rowspan="2">
                              <ww:hidden name="'form.stockDetailModelList['+#rows.index+'].task_code'" />
				  			  <ww:textarea name="'form.stockDetailModelList['+#rows.index+'].task_content'" value="task_content" cssClass="'control'" rows="3"></ww:textarea>
                            </td>
                            <td class="text-center" rowspan="2" style="width:6rem;">
                              <input type="button" value="参照" class="btn btn-primary dora-tabel-button" onclick="openWindowWithScrollbarGuide('initSagyounaiyouGuide.action?form.fieldName_code=form.stockDetailModelList[<%=temp%>].task_code&form.fieldName_name=form.stockDetailModelList[<%=temp%>].task_content','作業内容参照',670,600)">
                            </td>
                            <td class="text-center">
	                            <input type="number" name="form.stockDetailModelList[<ww:property value='#rows.index'/>].price_per" 
										value="<ww:property value='form.stockDetailModelList[#rows.index].price_per'/>" class="form-control text-right"
										oninput="maxNumberLength(8)" onKeypress="return integerOnly()"/>
                            </td>
                            <td class="text-center" >
                              <input type="number" name="form.stockDetailModelList[<ww:property value='#rows.index'/>].quantity" 
									value="<ww:property value='form.stockDetailModelList[#rows.index].quantity'/>" class="form-control text-right"
									oninput="maxNumberLength(8)" --onkeypress="return integerAndDecimal()" onchange="decimalLength(8,3)"/> 
                            </td>
                            <td class="text-center">
	                            <ww:select size="1" name="'form.stockDetailModelList['+#rows.index+'].unit_name_input'" 
									   cssClass="'form-control'" 
									   list="form.unit_name_list" 
									   listKey="code_id" 
									   listValue="code_value" 
									   value="unit_name_input" 
									   headerKey="''"
									   headerValue="'選択してください'"
								>
								</ww:select>
                            </td>
                            <td class="text-center">
	                            <input type="number" name="form.stockDetailModelList[<ww:property value='#rows.index'/>].amount" 
										value="<ww:property value='form.stockDetailModelList[#rows.index].amount'/>" class="form-control text-right"
										oninput="maxNumberLength(13)" onKeypress="return integerOnly()"/>
                            </td>
                            <td class="text-center"  rowspan="2">
                              <ww:checkbox  name="'form.stockDetailModelList['+#rows.index+'].isCheck'" fieldValue="'1'"></ww:checkbox>
                            </td>
                          </tr>
                          <tr>
                            <td class="text-center" ></td>
                            <td class="text-center" ></td>
                            <td class="text-center" >
	                            <ww:select size="1" name="'form.stockDetailModelList['+#rows.index+'].tax_div_input'" 
										   cssClass="'form-control'" 
										   list="form.tax_div_list" 
										   listKey="code_id" 
										   listValue="code_value" 
										   value="tax_div_input" 
										   headerKey="''"
										   headerValue="''"								   
								>
								</ww:select>
                            </td>
                            <td class="text-center" >
                               
                            </td>
                          </tr>
                          <%  temp ++; %>
						  </ww:iterator>
                        </tbody>
                        <tfoot>
                          <tr>
                            <td class="text-center" colspan="3"  rowspan="4"></td>
                            <td colspan="2">
                              <div class="checkbox" style="padding-left: 10rem;">
                                <label>
                                  合 計
                                </label>
                              </div>
                            </td>
                            <td class="text-right" colspan="2">
                            	<label id="stock_quantity_sum"><ww:property value="form.stock_quantity_sum"/></label>
                            </td>
                            <td rowspan="4"></td>
                          </tr>
                          <tr>
                            <td colspan="2">
                              <div class="checkbox"  style="padding-left: 10rem;">
                                <label>
                                  消 費 税
                                </label>
                              </div>
                            </td>
                            <td class="text-right" nowrap colspan="2">
                            	<label id="stock_consume_tax_sum"><ww:property value="form.stock_consume_tax_sum"/></label>
                            </td>
                          </tr>
                          <tr>
                            <td colspan="2">
                              <div class="checkbox" style="padding-left: 10rem;">
                                <label>
                                  税込合計
                                </label>
                              </div>
                
                            </td>
                            <td class="text-right" nowrap colspan="2">
                            	<label id="stock_quantity_tax_sum"><ww:property value="form.stock_quantity_tax_sum"/></label>
                            </td>
                          </tr>
                        </tfoot>
                      </table>
                      <div class="form-group" style="margin-bottom:1rem;">
                        <div>
                          <button type="button" class="btn btn-primary" id="addRow">明細行追加</button>
						  <button type="button" class="btn btn-primary" id="deleteRow">明細削除</button>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>

              <!---->
              <div class="row" style="margin:1rem 0 0 0.25rem">
                <div>
                  <label for="state">備考（最大長度１２５０漢字）</label>
                  <textarea name="form.remark" class="form-control" rows="5" placeholder="備考"><ww:property value='form.remark'/></textarea>
                </div>
              </div>
  
              <div class="form-group"  style="margin-top:1.25rem">
                <div>
					<ww:if test="form.pageId.equals(\"4\")">
						<button type="button" class="btn btn-primary dora-sm-button" onclick="submitAction(this.form,'showSiireYoteiItiran.action');">戻る</button>
					</ww:if>
					<ww:else>
						<!-- sxt 20220712 del start -->
<!-- 						<button type="button" class="btn btn-primary dora-sm-button" onclick="submitAction(this.form,'refreshSiire.action');">戻る</button> -->
						<!-- sxt 20220712 del end -->
						<!-- sxt 20220712 add start -->
						<ww:if test="form.modoruFlg.equals(\"1\")">
						    <button type="button" class="btn btn-primary dora-sm-button" onclick="hrefAction('returnProjectDetail.action')">戻る</button>
						</ww:if>
						<ww:else> 
						    <button type="button" class="btn btn-primary dora-sm-button" onclick="submitAction(this.form,'refreshSiire.action');">戻る</button>
						</ww:else>
						<!-- sxt 20220712 add end -->
					</ww:else> 
					<!-- sxt 20220721 del start -->
<!-- 					<button type="button" class="btn btn-primary dora-sm-button" onclick="submitAction(this.form,'saveSinkiSiire.action');">保存</button> -->
					<!-- sxt 20220712 del end -->
					<!-- sxt 20220721 add start -->
					<ww:if test="form.modoruFlg.equals(\"1\")">
					    <button type="button" class="btn btn-primary dora-sm-button" onclick="submitAction(this.form,'saveSinkiSiireFromProject.action');">保存</button>
					</ww:if>
					<ww:else> 
					    <button type="button" class="btn btn-primary dora-sm-button" onclick="submitAction(this.form,'saveSinkiSiire.action');">保存</button>
					</ww:else>
					<!-- sxt 20220712 add end -->
                </div>
              </div>
          </div>
        </div>
      </div>
      <ww:include value="'/footer.jsp'" />
    </div>
</form>
</body>
<ww:include value="'/footerJs.jsp'" />
	<script language="JavaScript">
		$(document).ready(function(){
			
			//合計金額計算
			calculateTotal();
			
			//明細行追加
			$("#addRow").click(function(){
				
				$.ajax({
			        type: "POST",  
			        url: "addSinkiSiire.action",
// 			        data: $('#mitumorinewform').serialize(),
// 			        async: false,
// 			        dataType:"html",
			        error: function (error) {  

			        },
			        success: function (data) {  	        	      
			        	addRow();
			        }
			    });
		
				function addRow(){
					var size = parseInt($("#detailsize").val());
					
					if (size == 90) {
						return false;
					}
					
					//最大行番号を取得する
					var maxRowNumber = parseInt($("input[name='form.stockDetailModelList[" + (size-1) +"].row_number'").val());
										
					//新しい５行を追加
					for (var i = 0; i < 5; i++) {
												
// 	 					$("#tbAddPart").append($("#tbAddPart tr").eq(0).clone());
// 	 		            $("#tbAddPart").append($("#tbAddPart tr").eq(1).clone());

						appendRow(i+size,i+maxRowNumber+1); 
					}
					
					$("#detailsize").val(5+size);
				}
							
			});
			
			function appendRow(n,rowNumber){
				//1行目をコピー
				var tr0 = $("#tbAddPart tr").eq(0).clone();
				
				//获得当前行第1个TD值
				var col0 = tr0.find("td:eq(0)"); 
				//获得当前TD的input标签 【行】
				var row_number = col0.find("input");
				//设置input标签name
				row_number.attr("name","form.stockDetailModelList[" + n + "].row_number");
				//设置input标签value
				row_number.attr("value",rowNumber); 
				
				//获得当前行第2个TD值 
				var col1 = tr0.find("td:eq(1)"); 
				//获得当前TD的input标签 【作業内容】
				var task_code = col1.find("input");
				task_code.attr("name","form.stockDetailModelList[" + n + "].task_code");
				task_code.attr("value",""); 
				task_code.val("");
				
				var task_content = col1.find("textarea");
				task_content.attr("name","form.stockDetailModelList[" + n + "].task_content");
				task_content.attr("value",""); 
				task_content.val("");
				
				//获得当前行第3个TD值 
				var col2 = tr0.find("td:eq(2)"); 
				//获得当前TD的input标签 【参照】
				var clickContent = "openWindowWithScrollbarGuide('initSagyounaiyouGuide.action?form.fieldName_code=form.stockDetailModelList[" + n + "].task_code&form.fieldName_name=form.stockDetailModelList[" + n+ "].task_content','作業内容参照',670,600)";
				var sanshoButton = col2.find("input");
				sanshoButton.attr("onclick",clickContent);
				sanshoButton.attr("name","button[" + n + "]");
				
				//获得当前行第4个TD值 
				var col3 = tr0.find("td:eq(3)"); 
				//获得当前TD的input标签 【単価】
				var price_per = col3.find("input");
				price_per.attr("name","form.stockDetailModelList[" + n + "].price_per");
				price_per.attr("value",""); 
				price_per.val("");

				//获得当前行第5个TD值 
				var col4 = tr0.find("td:eq(4)"); 
				//获得当前TD的input标签 【数量】
				var quantity = col4.find("input");
				quantity.attr("name","form.stockDetailModelList[" + n + "].quantity");
				quantity.attr("value",""); 
				quantity.val("");
				
				//获得当前行第6个TD值 
				var col5 = tr0.find("td:eq(5)"); 
				//获得当前TD的input标签 【単位】
				var unit_name_input = col5.find("select");
				unit_name_input.attr("name","form.stockDetailModelList[" + n + "].unit_name_input");
				unit_name_input.attr("value",""); 
				unit_name_input.val("");
				
				//获得当前行第7个TD值 
				var col6 = tr0.find("td:eq(6)"); 
				//获得当前TD的input标签 【単位】
				var amount = col6.find("input");
				amount.attr("name","form.stockDetailModelList[" + n + "].amount");
				amount.attr("value",""); 
				amount.val("");
				
				//获得当前行第8个TD值 
				var col7 = tr0.find("td:eq(7)"); 
				//获得当前TD的input标签  【checkbox】
				var checkbox = col7.find("input");
				checkbox.attr("name","form.stockDetailModelList[" + n + "].isCheck");
				checkbox.attr("value","0"); 
				checkbox.prop('checked',false)
				
				//1行目を追加
				tr0.appendTo("#tbAddPart");
				 
				//2行目をコピー
				var tr1 = $("#tbAddPart tr").eq(1).clone();
				
				//获得当前行第3个TD值 
				var tr1col2 = tr1.find("td:eq(2)"); 
				//获得当前TD的input标签 【税区分】
				var tax_div_input = tr1col2.find("select");
				tax_div_input.attr("name","form.stockDetailModelList[" + n + "].tax_div_input");
				tax_div_input.attr("value",""); 
				tax_div_input.val("");
				
				//获得当前行第4个TD值 
				var tr1col3 = tr1.find("td:eq(3)"); 
				//获得当前TD的input标签 【税区分】
				var org_price = tr1col3.find("input");
				org_price.attr("name","form.stockDetailModelList[" + n + "].org_price");
				org_price.attr("value",""); 
				org_price.val("");
				
				//2行目を追加
				tr1.appendTo("#tbAddPart");

			}
			
			//明細削除
			$("#deleteRow").click(function(){
				
				if (deleteSinkiSiire()) {
					$.ajax({
				        type: "POST",  
				        url: "deleteSinkiSiire.action",
//	 			        data: $('#mitumorinewform').serialize(),
//	 			        async: false,
//	 			        dataType:"html",
				        error: function (error) {  

				        },
				        success: function (data) {  	
					        	
				        	$("input[name$='isCheck']:checked").each(function() { 	
				        		
				        		var obj,start,end;
								
								// 获取checkbox所在行的顺序
								var n = $(this).parents("tr").index(); 
								
								obj = $(this).prop("name");
								//获取索引值
								start = obj.indexOf("[");
								end = obj.indexOf("]");
								
								//当前index
								var curIndex = parseInt(obj.substr(start+1,end-start-1));
								
								// 画面的一行实际上是有2行<tr>组成的，所有要删除2行tr
								removeRow(n);
								removeRow(n);
								
								var maxRowNuber;	//最大行番号
								var maxIndex;		//最大index

								$("input[name^='form.stockDetailModelList'][name$='row_number']").each(function() {
									//获取当前元素的name
									maxRowNuber = parseInt($(this).val());
									
									obj = $(this).prop("name");
									//获取索引值
									start = obj.indexOf("[");
									end = obj.indexOf("]");
									maxIndex = parseInt(obj.substr(start+1,end-start-1));
								
								});
															
								appendRow(maxIndex+1,maxRowNuber+1); 
								
								reSetRowIndex(curIndex);

				        	});
				        	
				        	//sxt 20220815 add start
				        	//合計金額計算
							calculateTotal();
							//sxt 20220815 add end
				        }
				    });
				}
				
			});
						
			function reSetRowIndex(curIndex){

				var obj,start,end,index;
				$("input[name^='form.stockDetailModelList'][name$='row_number']").each(function() {
					//获取当前元素的name
					rowNuber = parseInt($(this).val());
					
					input = $(this).prop("name");
					//获取索引值
					start = input.indexOf("[");
					end = input.indexOf("]");
					index = parseInt(input.substr(start+1,end-start-1));
							
					if (index > curIndex){

						$("input[name='form.stockDetailModelList[" + index +"].row_number'").attr("name","form.stockDetailModelList[" + (index-1) + "].row_number");
						$("input[name='form.stockDetailModelList[" + index +"].task_code'").attr("name","form.stockDetailModelList[" + (index-1) + "].task_code");
						$("textarea[name='form.stockDetailModelList[" + index +"].task_content'").attr("name","form.stockDetailModelList[" + (index-1) + "].task_content");
						
						var clickContent = "openWindowWithScrollbarGuide('initSagyounaiyouGuide.action?form.fieldName_code=form.stockDetailModelList[" + (index-1) + "].task_code&form.fieldName_name=form.stockDetailModelList[" + (index-1) + "].task_content','作業内容参照',670,600)";		
						$("input[name='button[" + index +"]'").attr("onclick",clickContent);
						$("input[name='button[" + index +"]'").attr("name","button[" + (index-1) + "]");
							
						$("input[name='form.stockDetailModelList[" + index +"].price_per'").attr("name","form.stockDetailModelList[" + (index-1) + "].price_per");
						$("input[name='form.stockDetailModelList[" + index +"].quantity'").attr("name","form.stockDetailModelList[" + (index-1) + "].quantity");
						$("select[name='form.stockDetailModelList[" + index +"].unit_name_input'").attr("name","form.stockDetailModelList[" + (index-1) + "].unit_name_input");
						$("input[name='form.stockDetailModelList[" + index +"].amount'").attr("name","form.stockDetailModelList[" + (index-1) + "].amount");
						$("input[name='form.stockDetailModelList[" + index +"].isCheck'").attr("name","form.stockDetailModelList[" + (index-1) + "].isCheck");
						$("select[name='form.stockDetailModelList[" + index +"].tax_div_input'").attr("name","form.stockDetailModelList[" + (index-1) + "].tax_div_input");
						$("input[name='form.stockDetailModelList[" + index +"].org_price'").attr("name","form.stockDetailModelList[" + (index-1) + "].org_price");
					}
					
				});	
			}
			
			function removeRow(n){			
				$("#tbAddPart tr").eq(n).remove();
			}
			
			/* 明細部単価blurイベント*/
			$("input[name$='price_per']").blur(function(){
						
				//获取当前元素的name
				var x = $(this).prop("name");
				//获取当前索引
				var index = getCurIndex(x);
				
				//金額計算
				calculateAmount(index);
			});
			
			/* 明細部数量blurイベント*/
			$("input[name$='quantity']").blur(function(){
				//获取当前元素的name
				var x = $(this).prop("name");
				//获取当前索引
				var index = getCurIndex(x);
				
				//金額計算
				calculateAmount(index);
			});
			
			$("select[name$='tax_div_input']").change(function(){
				//合計金額計算
				calculateTotal();
			});
		});
		
		//获取当前索引
		function getCurIndex(x){
			//获取索引值
			var start = x.indexOf("[");
			var end = x.indexOf("]");
			return  parseInt(x.substr(start+1,end-start-1));
		}
		
		function calculateAmount( index ) {
			//金額
			var amount;
			
			//単価
			var price = 0;
			if ($("input[name='form.stockDetailModelList[" + index +"].price_per'").val()){
				price = parseFloat($("input[name='form.stockDetailModelList[" + index +"].price_per'").val());
			}
			
			//数量
			var quantity = 0;
			if ($("input[name='form.stockDetailModelList[" + index +"].quantity'").val()){
				quantity = parseFloat($("input[name='form.stockDetailModelList[" + index +"].quantity'").val());
			}
			
			//金額
			amount = price * quantity;
			
			//端数処理
			amount = doProcessing(amount);

			if (amount != 0) {
				$("input[name='form.stockDetailModelList[" + index +"].amount'").val(amount);	
			} else {
				$("input[name='form.stockDetailModelList[" + index +"].amount'").val("");	
			}
			
			//合計金額計算
			calculateTotal();
		}
		
		//端数処理
		function doProcessing( amount ) {
			//端数処理
			var processing = $("input[name='form.fraction_processing'").val();

			//01=切り捨て、02=四捨五入、03=切り上げ
			switch (processing) {
			case "01":
				amount = Math.floor(amount);
				break;
			case "02":
				amount = Math.round(amount);
				break;
			case "03":
				amount = Math.ceil(amount);
				break;
			}
			
			return amount;
		}
		function doSomething(){

		}
		
		//合計金額計算
		function calculateTotal(){
			
			//画面.消費税率
			var tax_rate = $("input[name='form.consume_tax_rate'").val();
			
			//内税金額合計
			var innerProfit = 0;
			//外税金額合計
			var outterProfit = 0;
			//非課税等の金額合計
			var otherProfit = 0;
			//消費税率＝画面.消費税率/100
			var profit = parseFloat(tax_rate) / 100; 
						
			//内税税抜金額
			var innerNoProfit = 0;
			//外税税抜金額
			var outterNoProfit = 0;
			//非課税等の税抜金額
			var otherNoProfit = 0;
			
			var detailsize =  parseInt($("#detailsize").val());
						
			for (var i = 0; i < detailsize; i++) {
				
				//明細金額
				var amountDetail = 0;
				if ($("input[name='form.stockDetailModelList[" + i +"].amount'").val()) {
					amountDetail = parseInt($("input[name='form.stockDetailModelList[" + i +"].amount'").val());
				} 
				
				//明細税区分
				var tax_div = $("select[name='form.stockDetailModelList[" + i +"].tax_div_input'").val();
					
				//明細税区分未选择的场合，按外税（02）计算
				if (!tax_div) tax_div = "02";
				
				if (tax_div == "01") {
					//内税金額合計：税区分が内税の明細行の金額合計
					innerProfit += amountDetail;
				} else if (tax_div == "02") {
					//外税金額合計：税区分が外税の明細行の金額合計
					outterProfit += amountDetail;
				} else {
					//非課税等の金額合計：税区分が外税と内税以外の明細行の金額合計
					otherProfit += amountDetail;
				}
			}
			
			//内税消費税合計
			var innerTaxProfit = 0;
			//外税消費税合計
			var outterTaxProfit = 0;
			//非課税消費税合計
			var otherTaxProfit = 0;
						
			//内税消費税合計：内税金額合計/(1+消費税率)×消費税率 端数処理は「切り捨て」です。
			innerTaxProfit = Math.floor(innerProfit * profit / (1 + profit));
			
			//外税消費税合計：外税金額合計×消費税率 端数処理は得意先マスタ.端数処理です。
			outterTaxProfit = doProcessing(outterProfit * profit);
			
			//消費税合計
			var tax_amount = innerTaxProfit + outterTaxProfit + otherTaxProfit;		
			
// 			if(tax_amount < -999999999999||tax_amount > 999999999999){
// 				alert("消費税がオーバーです。");
// 			}
			
			//内税税抜金額：内税金額合計 - 内税消費税合計 
			innerNoProfit = innerProfit - innerTaxProfit;
			//外税税抜金額：外税金額合計
			outterNoProfit = outterProfit;
			//非課税等の税抜金額：非課税等の金額合計
			otherNoProfit = otherProfit;
			//合計
			var amount = innerNoProfit + outterNoProfit + otherNoProfit;
			
// 			if(amount < -999999999999||amount > 999999999999){
// 				alert("合計がオーバーです。");
// 			}else{
// 				$("#stock_quantity_sum").text("￥" + amount.toLocaleString());
// 				$("#stock_consume_tax_sum").text("￥" + tax_amount.toLocaleString());
// 				$("#stock_quantity_tax_sum").text("￥" + (amount + tax_amount).toLocaleString());				
// 			}
			
			$("#stock_quantity_sum").text("￥" + amount.toLocaleString());
			$("#stock_consume_tax_sum").text("￥" + tax_amount.toLocaleString());
			$("#stock_quantity_tax_sum").text("￥" + (amount + tax_amount).toLocaleString());	
		}
	</script>
</html>
