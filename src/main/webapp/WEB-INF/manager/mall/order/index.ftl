<@ms.html5>
    <@ms.nav title="商品管理" back=false>
	</@ms.nav>
    <@ms.searchForm name="searchForm" action="${managerPath}/mall/order/list.do">
    		<@ms.text name="orderNo" label="订 单 号"/>
    		<@ms.text name="orderUserName" label="收货人"/>
    		<@ms.text name="orderPhone" label="联系电话"/>
 			<@ms.select 
 				default="请选择"
 				defaultValue="-1"
			    name="orderStatus" 
			    label="订单状态" 
			    list=orderStatus
			    listKey="id" 
			    listValue="name"
			    value="${productShelf?default('')}"
			/>			
			
			<@ms.searchFormButton>
				 <@ms.queryButton onclick="search()"/> 
			</@ms.searchFormButton>			
	</@ms.searchForm>
    <@ms.panel>
    	<div id="toolbar">
    		<@ms.updateButton value="批量打印" id="sendButton" icon="" />
    	</div>
		<table id="orderTable"
			data-toolbar="#toolbar"
			data-detail-view="true" 
			data-show-refresh="true"
	        data-show-columns="true"
	        data-show-export="true"
			data-method="post" 
			data-detail-formatter="detailFormatter" 
			data-pagination="true"
			data-page-size="1"
			data-side-pagination="server">
		</table>
    </@ms.panel>
</@ms.html5>	        
 <script>
 		$(function() {
 			//对应bootstrap-table框架的控制
	        $("#orderTable").bootstrapTable({
	        		url:"${managerPath}/mall/order/list.do",
	        		contentType : "application/x-www-form-urlencoded",
	        		queryParams:function(params) {
						return  $.param(params)+"&pageSize="+ params.limit+"&pageNo="+(params.offset+1)+"&"+$("#searchForm").serialize();
					},
				    columns: [{ checkbox: true},{
				        field: 'orderNo',
				        title: '订单号'
				    }, {
				        field: 'peopleUser.peopleUserNickName',
				        title: '下单用户'
				    }, {
				    	sortable:true,
				        field: 'orderPrice',
				        title: '订单总额'
				    }, {
				        field: 'orderExprecessPrice',
				        title: '运费金额'
				    }, {
				        field: 'orderStatusTitle',
				        title: '订单状态'
				    }, {
				        field: 'orderPaymentTitle',
				        title: '支付方式'
				    }, {
				        field: 'orderTime',
				        title: '下单时间'
				    }]
	        }); 		
 		})
 		
 		//订单详情
 	   function detailFormatter(index, row) {
	        return $("#orderDetail").tmpl(row);
    	}
    	
 	   function search() {
 	   	$("#orderTable").bootstrapTable('refresh');
 	   }
 	   
 	   
 </script>
<script id="orderDetail" type="text/x-jquery-tmpl">
		<table class="table">
				{{each goods}} 
		        <tr>
		            <td width="70"><img src="<#noparse>${$value.goodsThumbnail}</#noparse>" width="62" height="62"/></td>
		            <td><#noparse>${$value.goodsName}</#noparse> <#noparse>${$value.goodsProductDetailText}</#noparse></td>
		            <td>x<#noparse>${$value.goodsNum}</#noparse></td>
		        </tr>
		        {{/each}}
		</table>
		<table class="table">
			<tr>
				<td>
				收货人信息<br/>
				收货人：<#noparse>${orderUserName}</#noparse><br/>
				地址： <#noparse>${orderAddress}</#noparse><br/>
				手机号码：<#noparse>${orderPhone}</#noparse><br/>
				</td>
			</tr>
		</table>
		<table class="table">
			<tr>
				<td>
				快递公司：<#noparse>${orderExpressTitle}</#noparse><br/>
				发货单号：<#noparse>${orderExpressNo}</#noparse><br/>
				发货费用：<#noparse>${orderExpressPrice}</#noparse><br/>
				</td>
			</tr>
		</table>		
		<table class="table">
			<tr>
				<td align="right">
					<button type="button" class="btn btn-primary expressOrder"  data-order-no="<#noparse>${orderNo}</#noparse>" >发货</button>
					<button type="button" class="btn btn-primary cancleOrder"   data-order-no="<#noparse>${orderNo}</#noparse>" >取消</button>
					<button type="button" class="btn btn-primary printOrder"  data-order-no="<#noparse>${orderNo}</#noparse>" >打印</button>
				</td>
			</tr>
		</table>
</script>

<@ms.modal id="expressOrderWindow"
        title="订单发货" 
        resetFrom=true
        size="M"
>
        <@ms.modalBody>
           <@ms.form  name="expressOrderForm" 
			 action="${managerPath}/mall/order/express.do" method="post"    class="form-horizontal"  
			style="form-horizontal" isvalidation=true tooltip=true>
				<input type="hidden" name="orderNo" id="expressOrderNo"/>
				<@ms.text
					name="orderExpressTitle" 
					label="快递公司" 
					width="200"   
					placeholder="这里要改成下拉选择快递公司" 
					validation={
					"maxlength":"50","required":"true","data-bv-notempty-message":"必填项目","data-bv-stringlength-message":"15个字符以内!"}/>
				<@ms.number label="价格"  
					name="orderExpressPrice" 
					label="快递价格"
					min=最小值
					max=最大值  
					isFloat=true
					value="0"
					help="根据快递公司自动获取费用"
				/>	
				<@ms.text
					name="orderExpressNo" 
					label="快递单号"
					width="200"   
					placeholder="请输入快递单号" 
					validation={
					"maxlength":"15","required":"true","data-bv-notempty-message":"必填项目","data-bv-stringlength-message":"15个字符以内!"}/>
			</@ms.form>
        </@ms.modalBody>
        <@ms.modalButton>
             <@ms.saveButton value="确认发货" postForm="expressOrderForm"/>
        </@ms.modalButton>
</@ms.modal>

<script>
	$(function() {
		$("#orderTable").delegate(".expressOrder","click",function() {
			$("#expressOrderNo").val($(this).data("order-no"));
			$("#expressOrderWindow").modal();
		});
	})
</script>