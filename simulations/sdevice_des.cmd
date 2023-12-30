File {  
	* output files:
	Output =  "IdxVg_L@L@-W@W@-H@H@-tox@tox@-tbox@tbox@-Nd@Nd@e18-Lfd@Lfd@_T@T@_n@node@_des.out"
	#ACExtract = "AC_L@L@-W@W@-H@H@-tox@tox@-tbox@tbox@-Nd@Nd@e18-Lfd@Lfd@_T@T@_n@node@_des.plt"
	Plot =    "IdxVg_L@L@-W@W@-H@H@-tox@tox@-tbox@tbox@-Nd@Nd@e18-Lfd@Lfd@_T@T@_n@node@_des.tdr"
	Current = "IdxVg_L@L@-W@W@-H@H@-tox@tox@-tbox@tbox@-Nd@Nd@e18-Lfd@Lfd@_T@T@_n@node@_des.plt"
	PMIPath = "."
}

Physics {
	Temperature=@T@
	Mobility (
	#	Phumob 
	#	Enormal
		HighFieldSaturation
	#	IncompleteIonization
		)
	#IncompleteIonization ( Model ( "pmi_incompleto" ("ArsenicActiveConcentration") ) )
	Recombination( SRH(DopingDep TempDependence)
	)	
	EffectiveIntrinsicDensity (BandGapNarrowing (OldSlotboom))
	#Noise (Traps )
}

#Physics (
#	RegionInterface="corpo/oxido") {
#	Traps (
#		(eNeutral Exponential fromCondBand Conc=@conc@ EnergyMid=0 EnergySig=@E@ eXsection=@CS@ hXsection=@CS@ )
		#(eNeutral Level fromMidBandGap Conc=2e12 EnergyMid=0 EnergySig=0.20 eXsection=1e-20 hXsection=1e-20 )
#	)
#}


Plot {
	AcceptorConcentration
	BandGap BandGapNarrowing 
	ConductionBandEnergy
	ConductionCurrent
	DielectricConstant
	DonorConcentration
	Doping 
	DisplacementCurrent
	eCurrent eDensity eDriftVelocity eEffectiveStateDensity eENormal eEparallel eEquilibriumDensity 
	eMobility eQuantumPotential eQuasiFermi eRelativeEffectiveMass eSaturationVelocity eVelocity
	EffectiveBandGap EffectiveIntrinsicDensity
	ElectricField
	ElectronAffinity
	Potential EquilibriumPotential
	hCurrent hDensity hDriftVelocity hEffectiveStateDensity hENormal hEparallel hEquilibriumDensity 
	hMobility hQuantumPotential hQuasiFermi hRelativeEffectiveMass hSaturationVelocity hVelocity
	IntrinsicDensity
	Temperature
	Current
	TotalRecombination
	ValenceBandEnergy
	SpaceCharge
	SRHRecombination 
}

Device JL{
	File { 
		* input files:
		Grid =    "L@L@-W@W@-H@H@-tox@tox@-tbox@tbox@-Nd@Nd@e18-Lfd@Lfd@_msh.tdr"
		Parameter = "Param.par"
		* output files:

	}
	Electrode {
		{ Name="fonte"     Voltage= 0.000 }
		{ Name="dreno"     Voltage= 0.000 }
		{ Name="porta"     Voltage= 0.000 Material="PolySi"(P) }
		{ Name="substrato" Voltage= 0.000 Material="Silicon"(P=1e15)}
	}
}



System {
	JL t1 (fonte=f dreno=d porta=g substrato=s) 
	Vsource_pset Vd (d 0) {dc=0}
	Vsource_pset Vg (g 0) {dc=0}
	Vsource_pset Vf (f 0) {dc=0}
	Vsource_pset Vs (s 0) {dc=0}
	Plot "IdxVg_L@L@-W@W@-H@H@-tox@tox@-tbox@tbox@-Nd@Nd@e18-Lfd@Lfd@_T@T@_n@node@_plt.txt" (v(g f) v(d f) v(s f) i(t1 f))
}


Math {
	Extrapolate
#	NotDamped=2
	Iterations=50
	ExitOnFailure
#	Smooth
	Method = Blocked SubMethod=ils
	ACMethod = Blocked ACSubMethod=ils(Set=2)
	number_of_threads = 2
#	LineSearchDamping = 0.01
}


Solve {

	Quasistationary	( Initialstep=1 Minstep=1e-12 Maxstep=1
		Goal {Parameter=Vg.dc Value=0 } Goal {Parameter=Vs.dc Value=@Vbs@ } )
		{Coupled(Iterations=50) { Poisson }  CurrentPlot ( Time = (-1)) }
			
	Quasistationary	( Initialstep=1 Minstep=1e-12 Maxstep=1
		Goal {Parameter=Vg.dc Value=1.2 } Goal {Parameter=Vs.dc Value=@Vbs@ } )
		{Coupled(Iterations=10) { Poisson Electron Hole Circuit Contact  }  CurrentPlot ( Time = (-1)) }

	Quasistationary	( Initialstep=1 Minstep=1e-12 Maxstep=1
		Goal {Parameter=Vd.dc Value=@Vd@ } )
		{Coupled(Iterations=50) { Poisson Electron Hole Circuit Contact  }  CurrentPlot ( Time = (-1)) }
	
	Quasistationary	( Initialstep=1 Minstep=1e-12 Maxstep=1 BreakCriteria{Current(DevName=t1 Node=f MinVal = 1e-13)}
		Goal {Parameter=Vg.dc Value=-0.5 })
		{Coupled(Iterations=50) { Poisson Electron Hole Circuit Contact  }  CurrentPlot ( Time = (range = (0 1) intervals = 170)) }
		
}

