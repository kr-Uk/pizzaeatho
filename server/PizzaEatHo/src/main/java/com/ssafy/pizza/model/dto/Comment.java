package com.ssafy.pizza.model.dto;

public class Comment {
    private Integer commentId;
    private Integer userId;
    private Integer productId;
    private Integer orderDetailId;
    private Integer rating;
    private String comment;
    private java.util.Date createdAt;
    
	public Comment(Integer commentId, Integer userId, Integer productId, Integer orderDetailId, Integer rating,
			String comment, java.util.Date createdAt) {
		this.commentId = commentId;
		this.userId = userId;
		this.productId = productId;
		this.orderDetailId = orderDetailId;
		this.rating = rating;
		this.comment = comment;
		this.createdAt = createdAt;
	}
	
    public Comment(Integer userId, Integer productId, Integer orderDetailId, Integer rating, String comment) {
        this.userId = userId;
        this.productId = productId;
        this.orderDetailId = orderDetailId;
        this.rating = rating;
        this.comment = comment;
    }
    
    public Comment() {
    	
    }

	public Integer getCommentId() {
		return commentId;
	}

	public void setCommentId(Integer commentId) {
		this.commentId = commentId;
	}

	public Integer getUserId() {
		return userId;
	}

	public void setUserId(Integer userId) {
		this.userId = userId;
	}

	public Integer getProductId() {
		return productId;
	}

	public void setProductId(Integer productId) {
		this.productId = productId;
	}

    public Integer getOrderDetailId() {
        return orderDetailId;
    }

    public void setOrderDetailId(Integer orderDetailId) {
        this.orderDetailId = orderDetailId;
    }

	public Integer getRating() {
		return rating;
	}

	public void setRating(Integer rating) {
		this.rating = rating;
	}

	public String getComment() {
		return comment;
	}

	public void setComment(String comment) {
		this.comment = comment;
	}

    public java.util.Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(java.util.Date createdAt) {
        this.createdAt = createdAt;
    }

	@Override
	public String toString() {
		return "Comment [commentId=" + commentId + ", userId=" + userId + ", productId=" + productId
				+ ", orderDetailId=" + orderDetailId + ", rating=" + rating + ", comment=" + comment + ", createdAt="
				+ createdAt + "]";
	}
    
    
    
}

