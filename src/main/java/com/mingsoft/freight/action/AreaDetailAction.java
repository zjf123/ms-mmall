/**
The MIT License (MIT) * Copyright (c) 2016 铭飞科技(mingsoft.net)

 * Permission is hereby granted, free of charge, to any person obtaining a copy of
 * this software and associated documentation files (the "Software"), to deal in
 * the Software without restriction, including without limitation the rights to
 * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
 * the Software, and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions:

 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.

 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
 * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
 * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

package com.mingsoft.freight.action;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;

import com.alibaba.fastjson.JSONArray;
import com.mingsoft.basic.action.BaseAction;
import com.mingsoft.basic.biz.ICategoryBiz;
import com.mingsoft.basic.constant.ModelCode;
import com.mingsoft.basic.entity.CategoryEntity;
import com.mingsoft.freight.biz.IAreaBiz;
import com.mingsoft.freight.biz.IAreaDetailBiz;
import com.mingsoft.freight.biz.IFreightBiz;
import com.mingsoft.freight.entity.AreaEntity;
import com.mingsoft.freight.entity.FreightEntity;
import com.mingsoft.freight.entity.AreaDetailEntity;

import net.mingsoft.basic.util.BasicUtil;

@Controller
@RequestMapping("/${managerPath}/freightAreaDetail")
public class AreaDetailAction extends BaseAction {
	
	@Autowired
	private IFreightBiz freightBiz;
	@Autowired
	private IAreaBiz freightAreaBiz;
	@Autowired
	private IAreaDetailBiz freightAreaDetailBiz;
	@Autowired
	private ICategoryBiz categoryBiz;
	
	/**
	 * 加载页面显示所有区域信息
	 * @param request
	 * @return
	 */
	@RequestMapping("/index")
	private String index(HttpServletRequest request){
		//左侧列表
		List<AreaEntity> listArea = freightAreaBiz.queryAllArea();
		request.setAttribute("listArea", listArea);
		return view("/freight/area_detail/index");
	}
	
	@RequestMapping("/list")
	private String list(HttpServletRequest request){
		//table
		int modelId = BasicUtil.getModelCodeId(net.mingsoft.mall.constant.ModelCode.MALL_CATEGORY);
		int faId = Integer.parseInt(request.getParameter("faId"));
		List<AreaDetailEntity> faList = freightAreaDetailBiz.queryAllFad(faId,modelId);
		request.setAttribute("faList", faList);
		request.setAttribute("faId", faId);
		return view("/freight/area_detail/area_detail_list");
	}
	/**
	 * 区域运费的修改和添加
	 * @param area
	 * @param response
	 * @param request
	 */
	@RequestMapping("/update")
	private void update(@ModelAttribute AreaDetailEntity faEntity, @ModelAttribute FreightEntity freightEntity,HttpServletResponse response, HttpServletRequest request){
		//查询区域信息是否存在
		AreaDetailEntity FreightAreaDetailEntity = freightAreaDetailBiz.getByFaEntity(faEntity);
		//修改或插入freight_area_detail表
		if(FreightAreaDetailEntity == null ){
			freightAreaDetailBiz.saveByFaEntity(faEntity);
		}else{
			freightAreaDetailBiz.updateByFaEntity(faEntity);
		}
		//修改或插入freigh表
		String fadAreaId = request.getParameter("fadAreaId");
		AreaEntity newEntity = new AreaEntity();
		newEntity.setFaId(Integer.parseInt(fadAreaId));
		AreaEntity freightAreaEntity = freightAreaBiz.getAreaEntity(newEntity);
		String faCityIds = freightAreaEntity.getFaCityIds();
		String[] faCityId = faCityIds.split(",");
		for(int i=0;i<faCityId.length;i++){
			freightEntity.setFreightCityId(Integer.parseInt(faCityId[i]));
			FreightEntity entity = freightBiz.queryByCityExpress(freightEntity);
			if(entity == null){
				freightBiz.saveEntity(freightEntity);
			}else{
				freightBiz.updateEntity(freightEntity);
			}
		}
	}
}