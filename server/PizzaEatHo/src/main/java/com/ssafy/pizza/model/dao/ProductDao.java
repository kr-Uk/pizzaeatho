package com.ssafy.pizza.model.dao;

import java.util.List;

import com.ssafy.pizza.model.dto.Crust;
import com.ssafy.pizza.model.dto.Dough;
import com.ssafy.pizza.model.dto.Product;
import com.ssafy.pizza.model.dto.Topping;

public interface ProductDao {
    List<Product> selectAll();

    List<Topping> selectDefaultToppings(Integer productId);

    List<Topping> selectAllToppings();

    List<Dough> selectAllDough();

    List<Crust> selectAllCrust();
}

