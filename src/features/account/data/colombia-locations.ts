export type ColombiaDepartment = {
  code: string;
  name: string;
  municipalities: Array<{ code: string; name: string }>;
};

// Versioned local catalog. Add municipalities here as VALDRA expands coverage;
// the server validates against the same codes before persisting a profile.
export const COLOMBIA_LOCATIONS_VERSION = "2026-01";

export const COLOMBIA_LOCATIONS: ColombiaDepartment[] = [
  { code: "AMA", name: "Amazonas", municipalities: [{ code: "AMA-LET", name: "Leticia" }] },
  { code: "ANT", name: "Antioquia", municipalities: [{ code: "ANT-MED", name: "Medellín" }, { code: "ANT-BEL", name: "Bello" }, { code: "ANT-ENV", name: "Envigado" }, { code: "ANT-ITA", name: "Itagüí" }, { code: "ANT-RIO", name: "Rionegro" }] },
  { code: "ARA", name: "Arauca", municipalities: [{ code: "ARA-ARA", name: "Arauca" }] },
  { code: "ATL", name: "Atlántico", municipalities: [{ code: "ATL-BAQ", name: "Barranquilla" }, { code: "ATL-SOL", name: "Soledad" }, { code: "ATL-MAL", name: "Malambo" }] },
  { code: "BOL", name: "Bolívar", municipalities: [{ code: "BOL-CTG", name: "Cartagena de Indias" }, { code: "BOL-MOM", name: "Mompox" }] },
  { code: "BOY", name: "Boyacá", municipalities: [{ code: "BOY-TUN", name: "Tunja" }, { code: "BOY-DUI", name: "Duitama" }, { code: "BOY-SOG", name: "Sogamoso" }] },
  { code: "CAL", name: "Caldas", municipalities: [{ code: "CAL-MAN", name: "Manizales" }, { code: "CAL-CHI", name: "Chinchiná" }] },
  { code: "CAQ", name: "Caquetá", municipalities: [{ code: "CAQ-FLO", name: "Florencia" }] },
  { code: "CAS", name: "Casanare", municipalities: [{ code: "CAS-YOP", name: "Yopal" }] },
  { code: "CAU", name: "Cauca", municipalities: [{ code: "CAU-POP", name: "Popayán" }] },
  { code: "CES", name: "Cesar", municipalities: [{ code: "CES-VAL", name: "Valledupar" }, { code: "CES-AGU", name: "Aguachica" }] },
  { code: "CHO", name: "Chocó", municipalities: [{ code: "CHO-QUI", name: "Quibdó" }] },
  { code: "COR", name: "Córdoba", municipalities: [{ code: "COR-MON", name: "Montería" }, { code: "COR-LOR", name: "Lorica" }] },
  { code: "CUN", name: "Cundinamarca", municipalities: [{ code: "CUN-BOG", name: "Bogotá D.C." }, { code: "CUN-GIR", name: "Girardot" }, { code: "CUN-SOI", name: "Soacha" }, { code: "CUN-ZIP", name: "Zipaquirá" }, { code: "CUN-FAC", name: "Facatativá" }] },
  { code: "GUA", name: "Guainía", municipalities: [{ code: "GUA-INO", name: "Inírida" }] },
  { code: "GUV", name: "Guaviare", municipalities: [{ code: "GUV-SJG", name: "San José del Guaviare" }] },
  { code: "HUI", name: "Huila", municipalities: [{ code: "HUI-NEI", name: "Neiva" }, { code: "HUI-PIT", name: "Pitalito" }] },
  { code: "LAG", name: "La Guajira", municipalities: [{ code: "LAG-RIO", name: "Riohacha" }, { code: "LAG-MAI", name: "Maicao" }] },
  { code: "MAG", name: "Magdalena", municipalities: [{ code: "MAG-SMR", name: "Santa Marta" }, { code: "MAG-CIE", name: "Ciénaga" }] },
  { code: "MET", name: "Meta", municipalities: [{ code: "MET-VIL", name: "Villavicencio" }, { code: "MET-ACA", name: "Acacías" }] },
  { code: "NAR", name: "Nariño", municipalities: [{ code: "NAR-PSO", name: "Pasto" }, { code: "NAR-IPO", name: "Ipiales" }] },
  { code: "NSA", name: "Norte de Santander", municipalities: [{ code: "NSA-CUC", name: "Cúcuta" }, { code: "NSA-OCA", name: "Ocaña" }] },
  { code: "PUT", name: "Putumayo", municipalities: [{ code: "PUT-MOC", name: "Mocoa" }] },
  { code: "QUI", name: "Quindío", municipalities: [{ code: "QUI-ARM", name: "Armenia" }, { code: "QUI-CAL", name: "Calarcá" }] },
  { code: "RIS", name: "Risaralda", municipalities: [{ code: "RIS-PER", name: "Pereira" }, { code: "RIS-DOS", name: "Dosquebradas" }] },
  { code: "SAP", name: "San Andrés y Providencia", municipalities: [{ code: "SAP-SAN", name: "San Andrés" }] },
  { code: "SAN", name: "Santander", municipalities: [{ code: "SAN-BUC", name: "Bucaramanga" }, { code: "SAN-FLO", name: "Floridablanca" }, { code: "SAN-BAR", name: "Barrancabermeja" }] },
  { code: "SUC", name: "Sucre", municipalities: [{ code: "SUC-SIN", name: "Sincelejo" }, { code: "SUC-COR", name: "Corozal" }] },
  { code: "TOL", name: "Tolima", municipalities: [{ code: "TOL-IBA", name: "Ibagué" }, { code: "TOL-ESP", name: "Espinal" }] },
  { code: "VAC", name: "Valle del Cauca", municipalities: [{ code: "VAC-CAL", name: "Cali" }, { code: "VAC-BUE", name: "Buenaventura" }, { code: "VAC-PAL", name: "Palmira" }, { code: "VAC-TUL", name: "Tuluá" }] },
  { code: "VAU", name: "Vaupés", municipalities: [{ code: "VAU-MIT", name: "Mitú" }] },
  { code: "VIC", name: "Vichada", municipalities: [{ code: "VIC-PTO", name: "Puerto Carreño" }] },
];

export function departmentByCode(code: string) {
  return COLOMBIA_LOCATIONS.find((department) => department.code === code);
}

export function municipalityIsValid(departmentCode: string, municipalityCode: string) {
  return Boolean(departmentByCode(departmentCode)?.municipalities.some((municipality) => municipality.code === municipalityCode));
}
