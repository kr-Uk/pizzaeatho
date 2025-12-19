package com.ssafy.pizza.model.dto;

public class User {
    private Integer userId;
    private String id;
    private String pw;
    private String name;
    private Integer stamp;

    public User(Integer userId, String id, String pw, String name, Integer stamp) {
        this.userId = userId;
        this.id = id;
        this.pw = pw;
        this.name = name;
        this.stamp = stamp;
    }
    
    public User() {}

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

    public String getPw() {
        return pw;
    }

    public void setPw(String pw) {
        this.pw = pw;
    }

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

    public Integer getStamp() {
        return stamp;
    }

    public void setStamp(Integer stamp) {
        this.stamp = stamp;
    }

	@Override
	public String toString() {
		return "User [userId=" + userId + ", id=" + id + ", pw=" + pw + ", name=" + name + ", stamp=" + stamp + "]";
	}
    
    
    
}

