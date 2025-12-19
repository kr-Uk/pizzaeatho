package com.ssafy.pizza.model.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ssafy.pizza.model.dao.ProductDao;
import com.ssafy.pizza.model.dto.Crust;
import com.ssafy.pizza.model.dto.Dough;
import com.ssafy.pizza.model.dto.Product;
import com.ssafy.pizza.model.dto.Topping;

@Service
public class ProductServiceImpl implements ProductService {

    @Autowired
    private ProductDao pDao;

    @Override
    public List<Product> getProductList() {
        return pDao.selectAll();
    }

    @Override
    public List<Topping> getDefaultToppings(Integer productId) {
        return pDao.selectDefaultToppings(productId);
    }

    @Override
    public List<Topping> getAllToppings() {
        return pDao.selectAllToppings();
    }

    @Override
    public List<Dough> getAllDough() {
        return pDao.selectAllDough();
    }

    @Override
    public List<Crust> getAllCrust() {
        return pDao.selectAllCrust();
    }
}

