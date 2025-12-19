package com.ssafy.pizza;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.web.servlet.error.ErrorController;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;


@Controller
public class Custom404ErrorController implements ErrorController {

    private static final Logger logger = LoggerFactory.getLogger(Custom404ErrorController.class);

	private final String ERROR_PATH = "/error";

	@GetMapping(ERROR_PATH)
	public String redirectRoot() {
		return "index.html";
	}

	public String getErrorPath() {
		return null;
	}
}
