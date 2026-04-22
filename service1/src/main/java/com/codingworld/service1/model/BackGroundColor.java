package com.codingworld.service1.model;


import javax.persistence.*;

@Entity
@Table(name = "background_colors")
public class BackGroundColor {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "color", nullable = false, unique = true)
    private String color;

    @Column(name = "active")
    private boolean active;

    public BackGroundColor() {
    }

    public BackGroundColor(String color, boolean active) {
        this.color = color;
        this.active = active;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getColor() {
        return color;
    }

    public void setColor(String color) {
        this.color = color;
    }

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }
}
