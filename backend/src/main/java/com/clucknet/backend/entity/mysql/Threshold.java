package com.clucknet.backend.entity.mysql;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "thresholds")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Threshold {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "zone_id", nullable = false)
    private Zone zone;

    @Column(name = "temperature_max")
    private Double temperatureMax;

    @Column(name = "humidity_max")
    private Double humidityMax;

    @Column(name = "humidity_min")
    private Double humidityMin;

    @Column(name = "nh3_max")
    private Double nh3Max;

    @Column(name = "lpg_max")
    private Double lpgMax;
}
