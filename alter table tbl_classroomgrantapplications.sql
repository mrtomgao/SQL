begin tran tom

  alter table [tbl_ClassroomGrantApplications] drop column 	SchoolRoom
  alter table [tbl_ClassroomGrantApplications] drop column 	ProjectorModel
  alter table [tbl_ClassroomGrantApplications] drop column 	ProjectorDistrictStandard
  alter table [tbl_ClassroomGrantApplications] drop column 	TVModel
  alter table [tbl_ClassroomGrantApplications] drop column 	TVDistrictStandard
  alter table [tbl_ClassroomGrantApplications] drop column 	PCModel
  alter table [tbl_ClassroomGrantApplications] drop column 	PCDistrictStandard
  alter table [tbl_ClassroomGrantApplications] drop column 	LaptopModel
  alter table [tbl_ClassroomGrantApplications] drop column 	LaptopDistrictStandard
  alter table [tbl_ClassroomGrantApplications] drop column 	TabletModel
  alter table [tbl_ClassroomGrantApplications] drop column 	TabletDistrictStandard
  alter table [tbl_ClassroomGrantApplications] drop column 	WirelessSlateModel
  alter table [tbl_ClassroomGrantApplications] drop column 	WirelessSlateDistrictStandard
  alter table [tbl_ClassroomGrantApplications] drop column 	DVDVCRModel
  alter table [tbl_ClassroomGrantApplications] drop column 	DVDVCRDistrictStandard
  alter table [tbl_ClassroomGrantApplications] drop column 	DocumentCameraModel
  alter table [tbl_ClassroomGrantApplications] drop column 	DocumentCameraDistrictStandard
  alter table [tbl_ClassroomGrantApplications] drop column 	InteractiveBoardModel
  alter table [tbl_ClassroomGrantApplications] drop column 	InteractiveBoardDistrictStandard
  alter table [tbl_ClassroomGrantApplications] drop column 	CableTVTunerModel
  alter table [tbl_ClassroomGrantApplications] drop column 	CableTVTunerDistrictStandard
  alter table [tbl_ClassroomGrantApplications] drop column 	SpeakersModel
  alter table [tbl_ClassroomGrantApplications] drop column 	SpeakersDistrictStandard
  alter table [tbl_ClassroomGrantApplications] drop column 	MicrophoneModel
  alter table [tbl_ClassroomGrantApplications] drop column 	MicrophoneDistrictStandard
  alter table [tbl_ClassroomGrantApplications] drop column 	ALSDeviceStudentCount
  alter table [tbl_ClassroomGrantApplications] drop column 	ExistingSpeakersInClassrooms
  alter table [tbl_ClassroomGrantApplications] drop column 	ExistingMicrophonesInSchools
  alter table [tbl_ClassroomGrantApplications] drop column 	ExistingVoiceAmpSystem
  alter table [tbl_ClassroomGrantApplications] drop column 	VABenefitIncreaseAttention
  alter table [tbl_ClassroomGrantApplications] drop column 	VABenefitDecreaseInterrupt
  alter table [tbl_ClassroomGrantApplications] drop column 	VABenefitDecreaseFatigue
  alter table [tbl_ClassroomGrantApplications] drop column 	VABenefitImproveScores
  alter table [tbl_ClassroomGrantApplications] drop column 	FutureMicAllClassrooms
  alter table [tbl_ClassroomGrantApplications] drop column 	ResellerCompany
  alter table [tbl_ClassroomGrantApplications] drop column 	ResellerName
  alter table [tbl_ClassroomGrantApplications] drop column 	ResellerPhone
  alter table [tbl_ClassroomGrantApplications] drop column 	ConsultantCompany
  alter table [tbl_ClassroomGrantApplications] drop column 	ConsultantName

  commit tran tom

  select * from [tbl_ClassroomGrantApplications]

rollback tran tom