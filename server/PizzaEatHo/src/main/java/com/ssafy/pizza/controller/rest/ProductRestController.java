package com.ssafy.pizza.controller.rest;

import java.util.List;
import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.ssafy.pizza.model.dto.Crust;
import com.ssafy.pizza.model.dto.DefaultToppingResponse;
import com.ssafy.pizza.model.dto.Dough;
import com.ssafy.pizza.model.dto.Product;
import com.ssafy.pizza.model.dto.Topping;
import com.ssafy.pizza.model.service.ProductService;

@RestController
@RequestMapping("/pizza")
@CrossOrigin("*")
public class ProductRestController {

    @Autowired
    private ProductService pService;

    @GetMapping("/product")
    public List<Product> getProductList() {
        return pService.getProductList();
    }

    @GetMapping("/product/{productId}/default-topping")
    public DefaultToppingResponse getDefaultToppings(@PathVariable Integer productId) {
        List<Topping> toppings = pService.getDefaultToppings(productId);
        List<Integer> ids = new ArrayList<>();
        for (Topping topping : toppings) {
            ids.add(topping.getToppingId());
        }
        return new DefaultToppingResponse(ids);
    }

    @GetMapping("/product/topping")
    public List<Topping> getAllToppings() {
        return pService.getAllToppings();
    }

    @GetMapping("/product/dough")
    public List<Dough> getAllDough() {
        return pService.getAllDough();
    }

    @GetMapping("/product/crust")
    public List<Crust> getAllCrust() {
        return pService.getAllCrust();
    }
}

